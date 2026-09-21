import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="share"
export default class extends Controller {
  static values = { url: String }

  copy() {
    navigator.clipboard.writeText(this.urlValue)
  .then(() => {
    console.log("テキストがクリップボードにコピーされました");
    this.element.hidePopover()
  })
  .catch((error) => {
    console.error("クリップボードへのコピーに失敗しました", error);
  });
  }
}
