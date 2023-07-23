import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="people-navbar"
export default class extends Controller {
  static targets = [ "allFriends", "peopleRegion", "suggestedFriends", "friendRequests" ]
  
  connect() {
    this.switchTemplate(this.suggestedFriendsTarget)
  }

  showAllFriends(e) {
    e.preventDefault()
    this.switchTemplate(this.allFriendsTarget)
  }

  showSuggestedFriends(e) {
    e.preventDefault()
    this.switchTemplate(this.suggestedFriendsTarget)
  }

  showFriendRequests(e) {
    e.preventDefault()
    this.switchTemplate(this.friendRequestsTarget)
  }

  switchTemplate(targetTemplate) {
    let template = targetTemplate.content.cloneNode(true)
    this.peopleRegionTarget.textContent = ""
    this.peopleRegionTarget.appendChild(template)
    console.log(this.peopleRegionTarget)
  }
}
