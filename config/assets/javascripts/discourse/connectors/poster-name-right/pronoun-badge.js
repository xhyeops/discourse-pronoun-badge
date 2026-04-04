import Component from "@glimmer/component";
import { inject as service } from "@ember/service";
import { htmlSafe } from "@ember/template";
import { emojiUnescape } from "discourse/lib/text";

export default class PronounBadgeConnector extends Component {
  @service siteSettings;

  get pronounField() {
    if (!this.siteSettings.pronoun_badge_enabled) {
      return null;
    }

    // Tenta obter dos dados do post
    const post = this.args.outletArgs?.post;
    if (post?.user_pronoun_field) {
      return post.user_pronoun_field;
    }

    // Fallback para dados do usuário
    const user = this.args.outletArgs?.user;
    if (user?.pronoun_field) {
      return user.pronoun_field;
    }

    return null;
  }

  get parsedPronoun() {
    const pronoun = this.pronounField;
    if (!pronoun) return "";
    
    // Processa emojis no texto
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
