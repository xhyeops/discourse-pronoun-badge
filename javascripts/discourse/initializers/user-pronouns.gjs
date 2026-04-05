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

export default {
  name: "user-pronouns",
  
  initialize(container) {
    const siteService = container.lookup("service:site");
    const fieldName = settings.pronouns_field_name || "Pronomes";
    
    withPluginApi("1.35.0", (api) => {
      
      // Posts - após o nome do autor
      api.renderAfterWrapperOutlet(
        "post-meta-data-poster-name",
        class extends Component {
          @service site;
          
          static shouldRender(args) {
            const userFields = args.post?.user_fields;
            if (!userFields) return false;
            
            const siteFields = siteService?.user_fields;
            if (!siteFields) return false;
            
            const field = siteFields.find(
              (f) => f.name.toLowerCase() === fieldName.toLowerCase()
            );
            
            if (!field) return false;
            
            return !!userFields[field.id];
          }

          get pronouns() {
            const userFields = this.args.post?.user_fields;
            return getPronouns(userFields, this.site?.user_fields, fieldName);
          }

          get formattedPronouns() {
            if (!this.pronouns) return null;
            return htmlSafe(emojiUnescape(this.pronouns));
          }

          <template>
            <span class="user-pronouns-badge">{{this.formattedPronouns}}</span>
          </template>
        }
      );
      
      // User card
      api.renderAfterWrapperOutlet(
        "user-card-after-username",
        class extends Component {
          @service site;
          
          static shouldRender(args) {
            const userFields = args.user?.user_fields;
            if (!userFields) return false;
            
            const siteFields = siteService?.user_fields;
            if (!siteFields) return false;
            
            const field = siteFields.find(
              (f) => f.name.toLowerCase() === fieldName.toLowerCase()
            );
            
            if (!field) return false;
            
            return !!userFields[field.id];
          }

          get pronouns() {
            const userFields = this.args.user?.user_fields;
            return getPronouns(userFields, this.site?.user_fields, fieldName);
          }

          get formattedPronouns() {
            if (!this.pronouns) return null;
            return htmlSafe(emojiUnescape(this.pronouns));
          }

          <template>
            <span class="user-pronouns-badge">{{this.formattedPronouns}}</span>
          </template>
        }
      );
      
      // Perfil
      api.renderAfterWrapperOutlet(
        "user-profile-primary-after-username",
        class extends Component {
          @service site;
          
          static shouldRender(args) {
            const userFields = args.model?.user_fields;
            if (!userFields) return false;
            
            const siteFields = siteService?.user_fields;
            if (!siteFields) return false;
            
            const field = siteFields.find(
              (f) => f.name.toLowerCase() === fieldName.toLowerCase()
            );
            
            if (!field) return false;
            
            return !!userFields[field.id];
          }

          get pronouns() {
            const userFields = this.args.model?.user_fields;
            return getPronouns(userFields, this.site?.user_fields, fieldName);
          }

          get formattedPronouns() {
            if (!this.pronouns) return null;
            return htmlSafe(emojiUnescape(this.pronouns));
          }

          <template>
            <span class="user-pronouns-badge">{{this.formattedPronouns}}</span>
          </template>
        }
      );
    });
  }
};
