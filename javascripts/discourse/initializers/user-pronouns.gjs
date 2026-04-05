import Component from "@glimmer/component";
import { service } from "@ember/service";
import { withPluginApi } from "discourse/lib/plugin-api";
import { htmlSafe } from "@ember/template";
import { emojiUnescape } from "discourse/lib/text";

function findField(siteFields, fieldName) {
  if (!siteFields || !fieldName) return null;

  return siteFields.find(
    (f) => (f.name || "").trim().toLowerCase() === fieldName.trim().toLowerCase()
  );
}

function getPronouns(source, siteFields, fieldName) {
  if (!source || !siteFields) return null;

  const field = findField(siteFields, fieldName);
  if (!field) return null;

  return (
    source.user_fields?.[field.id] ||
    source.user_fields?.[String(field.id)] ||
    source.custom_fields?.[`user_field_${field.id}`] ||
    source.custom_fields?.[field.id] ||
    source.custom_fields?.[String(field.id)] ||
    null
  );
}

function buildPronounsComponent(getSource, fieldName) {
  return class extends Component {
    @service site;

    get pronouns() {
      const source = getSource(this.args);
      return getPronouns(source, this.site?.user_fields, fieldName);
    }

    get formattedPronouns() {
      if (!this.pronouns) return null;
      return htmlSafe(emojiUnescape(String(this.pronouns)));
    }

    <template>
      {{#if this.formattedPronouns}}
        <span class="user-pronouns-badge">{{this.formattedPronouns}}</span>
      {{/if}}
    </template>
  };
}

export default {
  name: "user-pronouns",

  initialize() {
    const fieldName = settings.pronouns_field_name || "Pronomes";

    withPluginApi("1.35.0", (api) => {
      api.renderAfterWrapperOutlet(
        "post-meta-data-poster-name",
        buildPronounsComponent((args) => args.post, fieldName)
      );

      api.renderAfterWrapperOutlet(
        "user-card-after-username",
        buildPronounsComponent((args) => args.user, fieldName)
      );

      api.renderAfterWrapperOutlet(
        "user-profile-primary-after-username",
        buildPronounsComponent((args) => args.model, fieldName)
      );
    });
  }
};
