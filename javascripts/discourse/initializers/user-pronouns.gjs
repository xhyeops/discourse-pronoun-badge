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
      
      api.addPosterIcons((cfs, attrs) => {
        const userFields = attrs.user_fields || cfs;
        
        if (!userFields || !site?.user_fields) return [];
        
        const field = site.user_fields.find(
          (f) => f.name.toLowerCase() === fieldName.toLowerCase()
        );
        
        if (!field) return [];
        
        const pronouns = userFields[field.id];
        
        if (!pronouns) return [];
        
        return [{
          className: "user-pronouns-badge",
          text: pronouns,
          title: pronouns
        }];
      });
    });
  }
};
