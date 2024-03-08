import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modals"
export default class extends Controller {
  static targets = ['modal','backGround']

  closeModal() {
    //"hidden"クラスを追加し、モーダルを閉じます。
    this.backGroundTarget.classList.add("hidden");
  }
  // モーダルの外をクリックした際に、モーダルを閉じるアクション
  closeBackground(event) {
    //アクションを呼び出しているターゲットとbackGroundTargetが同じ場合はtrueを返す。（モーダルの外をクリックしているか）
    if(event.target === this.backGroundTarget) {
      //closeModalアクションを呼び出す。
      this.closeModal();
    }
  }
}
