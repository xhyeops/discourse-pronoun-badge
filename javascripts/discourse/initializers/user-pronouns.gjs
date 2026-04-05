import Component from "@glimmer/component";
import { service } from "@ember/service";
import { withPluginApi } from "discourse/lib/plugin-api";
import { htmlSafe } from "@ember/template";
import { emojiUnescape } from "discourse/lib/text";

// Badge para User Card
class UserCardPronounsBadge extends Component {
  @service site;

  get fieldName() {
    return window.settings?.pronouns_field_name || "Pronomes";
  }

  get pronouns() {
    console.log("[v0] UserCardPronounsBadge - outletArgs:", this.args.outletArgs);
    
    const user = this.args.outletArgs?.user;
    if (!user) return null;
    
    const userFields = user.user_fields;
    console.log("[v0] user_fields:", userFields);
    
    if (!userFields) return null;
    
    const siteFields = this.site?.user_fields;
    console.log("[v0] site.user_fields:", siteFields);
    
    if (!siteFields) return null;
    
    const field = siteFields.find(
      (f) => f.name.toLowerCase() === this.fieldName.toLowerCase()
    );
    
    console.log("[v0] field encontrado:", field);
    
    if (!field) return null;
    
    return userFields[field.id];
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
  @service site;

  get fieldName() {
    return window.settings?.pronouns_field_name || "Pronomes";
  }

  get pronouns() {
    console.log("[v0] PostPronounsBadge - outletArgs:", this.args.outletArgs);
    
    const post = this.args.outletArgs?.post;
    if (!post) return null;
    
    const userFields = post.user_fields || post.user?.user_fields;
    console.log("[v0] post userFields:", userFields);
    
    if (!userFields) return null;
    
    const siteFields = this.site?.user_fields;
    if (!siteFields) return null;
    
    const field = siteFields.find(
      (f) => f.name.toLowerCase() === this.fieldName.toLowerCase()
    );
    
    if (!field) return null;
    
    return userFields[field.id];
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
  @service site;

  get fieldName() {
    return window.settings?.pronouns_field_name || "Pronomes";
  }

  get pronouns() {
    console.log("[v0] ProfilePronounsBadge - outletArgs:", this.args.outletArgs);
    
    const model = this.args.outletArgs?.model;
    if (!model) return null;
    
    const userFields = model.user_fields;
    console.log("[v0] profile userFields:", userFields);
    
    if (!userFields) return null;
    
    const siteFields = this.site?.user_fields;
    if (!siteFields) return null;
    
    const field = siteFields.find(
      (f) => f.name.toLowerCase() === this.fieldName.toLowerCase()
    );
    
    if (!field) return null;
    
    return userFields[field.id];
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

// Inicialização
function initializeUserPronouns(api) {
  console.log("[v0] user-pronouns iniciando");
  
  api.renderInOutlet("user-card-after-username", UserCardPronounsBadge);
  api.renderInOutlet("user-profile-primary-after-username", ProfilePronounsBadge);
  api.renderInOutlet("poster-name-after-name", PostPronounsBadge);
  
  console.log("[v0] outlets registrados");
}

export default {
  name: "user-pronouns",
  
  initialize() {
    withPluginApi("1.35.0", initializeUserPronouns);
  }
};
