import Component from "@glimmer/component";
import { apiInitializer } from "discourse/lib/api";

function getUserFieldValue(post, fieldId) {
  // Tenta acessar de várias formas possíveis no Discourse
  const fieldKey = `user_field_${fieldId}`;
  
  return (
    post?.user_custom_fields?.[fieldKey] ||
    post?.user?.custom_fields?.[fieldKey] ||
    post?.user?.user_fields?.[String(fieldId)]
  );
}

export default apiInitializer("1.0.0", (api) => {
  const fieldId = api.container.lookup("service:site-settings").user_field_id || 1;

  api.renderAfterWrapperOutlet(
    "post-meta-data-poster-name",
    class UserFieldDisplay extends Component {
      static shouldRender(args) {
        const value = getUserFieldValue(args.post, fieldId);
        return value && String(value).trim() !== "";
      }

      get userFieldValue() {
        return getUserFieldValue(this.args.post, fieldId);
      }

      <template>
        <span class="poster-user-field">
          {{this.userFieldValue}}
        </span>
      </template>
    }
  );
});
