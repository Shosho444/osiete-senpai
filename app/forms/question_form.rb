class QuestionForm
  require 'csv'
  include ActiveModel::Model # 通常のモデルのようにvalidationなどを使えるようにする
  include ActiveModel::Attributes # ActiveRecordのカラムのような属性を加えられるようにする
  include ActiveModel::Validations::Callbacks

  attr_accessor :body

  attribute :user_id, :integer
  attribute :subject, :string
  attribute :deadline_date, :date
  attribute :deadline_time, :string
  attribute :deadline, :datetime
  attribute :profession_ids

  before_validation :deadline_create

  validates :user_id, presence: true
  validates :subject, length: { maximum: 255, minimum: 5 }
  validates :body, length: { maximum: 10_666, minimum: 5 }
  validate :finish_check
  validates :profession_ids, presence: { message: 'を選択してください' }

  def save
    return false if invalid?

    keyword = key_check(subject)
    return false unless keyword

    # トランザクションを使用し、データを保存
    ActiveRecord::Base.transaction do
      ids = []
      profession_number = profession_ids.map(&:to_i)
      profession_number.each do |industry_id|
        profession = Profession.find_or_create_by!(industry: industry_id)
        ids << profession.id
      end

      Question.create!(question_params(ids, keyword))
    end
    true
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error e.message
    false
    # saveメソッドの返り値はboolean型を返すためtrueを明示
  end

  private

  def finish_check
    errors.add(:base, '日付と時間の両方を入力してください') if deadline_date.present? ^ deadline_time.present?

    return if deadline.blank?

    if Time.current.hour < 12
      errors.add(:deadline, 'は明日以降の時間を選択してください') if deadline < Time.current.midnight.tomorrow
    elsif deadline < Time.current.midnight.since(2.days)
      errors.add(:deadline, 'は明後日以降の時間を選択してください')
    end
  end

  def deadline_create
    return unless deadline_date.present? && deadline_time.present?

    self.deadline = Time.zone.parse("#{deadline_date} #{deadline_time}:00:00")
  end

  def question_params(params_ids, params_keyword)
    {
      body:,
      subject:,
      user_id:,
      deadline:,
      keyword: params_keyword,
      profession_ids: params_ids
    }
  end

  def comprehend_client
    Aws::Comprehend::Client.new(
      region: 'ap-northeast-1',
      access_key_id: Rails.application.credentials[:aws][:access_key_id],
      secret_access_key: Rails.application.credentials[:aws][:secret_access_key]
    )
  end

  def key_check(subject_text)
    comprehend = comprehend_client

    response = comprehend.detect_key_phrases(text: subject_text, language_code: 'ja')
    response.key_phrases.map { |array| mecab(array.text) }.join(',')
  rescue StandardError
    errors.add(:base, 'もう一度テーマを入力してください')
    false
  end

  def mecab(subject_text)
    mecab = Natto::MeCab.new.parse(subject_text)
    array = CSV.parse(mecab.tr(',', "\t"), col_sep: "\t")
    result = array.filter_map { |element| element[0] unless element[1] == '助詞' || element.size == 1 }
    result.join(',')
  end
end
