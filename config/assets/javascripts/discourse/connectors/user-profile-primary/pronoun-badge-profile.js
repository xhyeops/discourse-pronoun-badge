import Component from "@glimmer/component";
import { inject as service } from "@ember/service";
import { htmlSafe } from "@ember/template";
import { emojiUnescape } from "discourse/lib/text";

export default class PronounBadgeProfileConnector extends Component {
  @service siteSettings;

  get pronounField() {
    if (!this.siteSettings.pronoun_badge_enabled) {
      return null;
    }

    const user = this.args.outletArgs?.model;
    return user?.pronoun_field || null;
  }

  get parsedPronoun() {
    const pronoun = this.pronounField;
    if (!pronoun) return "";
    
    return emojiUnescape(pronoun);
  }

  get badgeStyle() {
    const borderColor = this.siteSettings.pronoun_badge_border_color || "#e91e63";
    const textColor = this.siteSettings.pronoun_badge_text_color || "inherit";
    const bgColor = this.siteSettings.pronoun_badge_background_color || "transparent";
    
    return htmlSafe(
      `border-color: ${borderColor}; color: ${textColor}; background-color: ${bgColor};`
    );
  }
}
