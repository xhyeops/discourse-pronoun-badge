import Component from "@glimmer/component";
import { apiInitializer } from "discourse/lib/api";

export default apiInitializer("1.0.0", (api) => {
  api.renderAfterWrapperOutlet(
    "post-meta-data-poster-name",
    class UserFieldDisplay extends Component {
      static shouldRender(args) {
        const value = args.post?.user?.custom_fields?.user_field_1;
        return value && value.trim() !== "";
      }

      get userFieldValue() {
        return this.args.post?.user?.custom_fields?.user_field_1;
      }

      <template>
        <span class="poster-user-field">
          {{this.userFieldValue}}
        </span>
      </template>
    }
  );
});
