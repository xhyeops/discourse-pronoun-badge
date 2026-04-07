import Component from "@glimmer/component";
import { apiInitializer } from "discourse/lib/api";

export default apiInitializer((api) => {
  api.renderAfterWrapperOutlet(
    "poster-name:after",
    class UserFieldDisplay extends Component {
      // Só renderiza se o user field existir
      static shouldRender(args) {
        return args.post?.user?.custom_fields?.user_field_1;
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
