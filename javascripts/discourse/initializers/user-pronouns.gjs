import Component from "@glimmer/component";
import { service } from "@ember/service";
import { withPluginApi } from "discourse/lib/plugin-api";
import { htmlSafe } from "@ember/template";
import { emojiUnescape } from "discourse/lib/text";

function getPronouns(userFields, siteFields, fieldName) {
  if (!userFields || !siteFields) return null;
  
  const field = siteFields.find(
    (f) => f.name.toLowerCase() === fieldName.toLowerCase()
  );
  
  if (!field) return null;
  
  return userFields[field.id];
}

class UserCardPronounsBadge extends Component {
  @service site;

  get fieldName() {
    return settings.pronouns_field_name || "Pronomes";
  }

  get pronouns() {
    const user = this.args.outletArgs?.user;
    if (!user) return null;
    return getPronouns(user.user_fields, this.site?.user_fields, this.fieldName);
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

class ProfilePronounsBadge extends Component {
  @service site;

  get fieldName() {
    return settings.pronouns_field_name || "Pronomes";
  }

  get pronouns() {
    const model = this.args.outletArgs?.model;
    if (!model) return null;
    return getPronouns(model.user_fields, this.site?.user_fields, this.fieldName);
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
  
  initialize(container) {
    const site = container.lookup("service:site");
    const fieldName = settings.pronouns_field_name || "Pronomes";
    
    withPluginApi("1.35.0", (api) => {
      api.renderInOutlet("user-card-after-username", UserCardPronounsBadge);
      api.renderInOutlet("user-profile-primary-after-username", ProfilePronounsBadge);
      
      // Adiciona pronomes ao lado do nome nos posts
      api.decorateWidget("poster-name:after", (helper) => {
        const attrs = helper.attrs;
        
        console.log("[v0] decorateWidget poster-name:after - attrs:", attrs);
        
        const userFields = attrs.user_fields;
        console.log("[v0] userFields:", userFields);
        
        if (!userFields || !site?.user_fields) {
          console.log("[v0] userFields ou site.user_fields não disponível");
          return;
        }
        
        const field = site.user_fields.find(
          (f) => f.name.toLowerCase() === fieldName.toLowerCase()
        );
        
        console.log("[v0] field encontrado:", field);
        
        if (!field) return;
        
        const pronouns = userFields[field.id];
        console.log("[v0] pronouns:", pronouns);
        
        if (!pronouns) return;
        
        return helper.h("span.user-pronouns-badge", emojiUnescape(pronouns));
      });
    });
  }
};
