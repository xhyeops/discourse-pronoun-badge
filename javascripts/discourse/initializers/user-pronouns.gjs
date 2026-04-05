import Component from "@glimmer/component";
import { service } from "@ember/service";
import { withPluginApi } from "discourse/lib/plugin-api";
import { htmlSafe } from "@ember/template";
import { emojiUnescape } from "discourse/lib/text";

function getUserField(userFields, siteFields, fieldName) {
  if (!userFields || !siteFields) return null;

  const field = siteFields.find(
    (f) => f.name.toLowerCase() === fieldName.toLowerCase()
  );

  if (!field) return null;

  return userFields[field.id];
}

export default {
  name: "user-custom-field",

  initialize() {
    const fieldName = settings.pronouns_field_name || "Pronomes";

    withPluginApi("1.35.0", (api) => {
      
      function buildComponent(getUser) {
        return class extends Component {
          @service site;

          get value() {
            const user = getUser(this.args);
            const userFields = user?.user_fields;

            return getUserField(
              userFields,
              this.site?.user_fields,
              fieldName
            );
          }

          get formattedValue() {
            if (!this.value) return null;
            return htmlSafe(emojiUnescape(this.value));
          }

          <template>
            {{#if this.formattedValue}}
              <span class="user-pronouns-badge">
                {{this.formattedValue}}
              </span>
            {{/if}}
          </template>
        };
      }

      // POSTS (ao lado do nome)
      api.renderAfterWrapperOutlet(
        "post-meta-data-poster-name",
        buildComponent((args) => args.post)
      );

      // USER CARD
      api.renderAfterWrapperOutlet(
        "user-card-after-username",
        buildComponent((args) => args.user)
      );

      // PERFIL
      api.renderAfterWrapperOutlet(
        "user-profile-primary-after-username",
        buildComponent((args) => args.model)
      );
    });
  },
};
