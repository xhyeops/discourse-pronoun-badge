import Component from "@glimmer/component";
import { withPluginApi } from "discourse/lib/plugin-api";
import { htmlSafe } from "@ember/template";
import { emojiUnescape } from "discourse/lib/text";

function getPronounsFromUserFields(user, fieldName) {
  if (!user) return null;
  
  const userFields = user.user_fields;
  if (!userFields) return null;

  // Busca o site para pegar o ID do campo pelo nome
  const site = window.Discourse?.Site?.current?.() || window.Discourse?.Site?.currentProp?.();
  if (!site?.user_fields) return null;

  // Encontra o campo pelo nome
  const field = site.user_fields.find(
    (f) => f.name.toLowerCase() === fieldName.toLowerCase()
  );
  
  if (!field) return null;
  
  return userFields[field.id];
}

// Badge para User Card
class UserCardPronounsBadge extends Component {
  get fieldName() {
    return settings.pronouns_field_name || "Pronomes";
  }

  get pronouns() {
    const user = this.args.outletArgs?.user;
    return getPronounsFromUserFields(user, this.fieldName);
  }

  get formattedPronouns() {
    if (!this.pronouns) return null;
    return htmlSafe(emojiUnescape(this.pronouns));
  }

  <template>
    {{#if this.formattedPronouns}}
      <span class="user-pronouns-badge">{{this.formattedPronouns}}</span>
    {{/if}}
  </template>
}

// Badge para Posts
class PostPronounsBadge extends Component {
  get fieldName() {
    return settings.pronouns_field_name || "Pronomes";
  }

  get pronouns() {
    const post = this.args.outletArgs?.post;
    if (!post?.user) return null;
    return getPronounsFromUserFields(post.user, this.fieldName);
  }

  get formattedPronouns() {
    if (!this.pronouns) return null;
    return htmlSafe(emojiUnescape(this.pronouns));
  }

  <template>
    {{#if this.formattedPronouns}}
      <span class="user-pronouns-badge">{{this.formattedPronouns}}</span>
    {{/if}}
  </template>
}

// Badge para Perfil
class ProfilePronounsBadge extends Component {
  get fieldName() {
    return settings.pronouns_field_name || "Pronomes";
  }

  get pronouns() {
    const model = this.args.outletArgs?.model;
    return getPronounsFromUserFields(model, this.fieldName);
  }

  get formattedPronouns() {
    if (!this.pronouns) return null;
    return htmlSafe(emojiUnescape(this.pronouns));
  }

  <template>
    {{#if this.formattedPronouns}}
      <span class="user-pronouns-badge">{{this.formattedPronouns}}</span>
    {{/if}}
  </template>
}

export default {
  name: "user-pronouns",
  initialize() {
    withPluginApi("1.35.0", (api) => {
      // User card - ao lado do nome
      api.renderInOutlet("user-card-after-username", UserCardPronounsBadge);
      
      // Perfil do usuário
      api.renderInOutlet("user-profile-primary-after-username", ProfilePronounsBadge);
      
      // Posts - depois do nome do autor
      api.renderInOutlet("poster-name-after-name", PostPronounsBadge);
    });
  },
};
