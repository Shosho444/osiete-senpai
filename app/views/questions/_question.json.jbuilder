json.extract! question, :id, :user_id, :subject, :body, :deadline, :created_at, :updated_at
json.url question_url(question, format: :json)
