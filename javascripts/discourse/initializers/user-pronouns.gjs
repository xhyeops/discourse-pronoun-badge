import Component from "@glimmer/component";
import { service } from "@ember/service";
import { withPluginApi } from "discourse/lib/plugin-api";
import { htmlSafe } from "@ember/template";
import { emojiUnescape } from "discourse/lib/text";

function getPronounsFromUserFields(user, fieldName, context) {
  console.log("[v0] getPronounsFromUserFields chamado de:", context);
  console.log("[v0] user:", user);
  console.log("[v0] fieldName:", fieldName);
  
  if (!user) {
    console.log("[v0] user é null/undefined");
    return null;
  }
  
  const userFields = user.user_fields;
  console.log("[v0] user.user_fields:", userFields);
  
  if (!userFields) {
    console.log("[v0] user_fields não existe");
    return null;
  }

  // Tenta acessar o site de diferentes formas
  let site = null;
  if (typeof Discourse !== "undefined") {
    site = Discourse.Site?.current?.() || Discourse.Site?.currentProp?.("user_fields");
    console.log("[v0] site via Discourse:", site);
  }
  
  if (!site?.user_fields) {
    // Tenta via container
    const container = window.Discourse?.__container__;
    if (container) {
      const siteService = container.lookup("service:site");
      site = siteService;
      console.log("[v0] site via container:", site);
    }
  }

  if (!site?.user_fields) {
    console.log("[v0] site.user_fields não encontrado");
    // Fallback: tenta iterar pelos campos diretamente
    console.log("[v0] Tentando fallback com Object.entries");
    const entries = Object.entries(userFields);
    console.log("[v0] userFields entries:", entries);
    return null;
  }

  console.log("[v0] site.user_fields:", site.user_fields);

  const field = site.user_fields.find(
    (f) => f.name.toLowerCase() === fieldName.toLowerCase()
  );
  
  console.log("[v0] campo encontrado:", field);
  
  if (!field) return null;
  
  const value = userFields[field.id];
  console.log("[v0] valor do campo:", value);
  
  return value;
}

// Badge para User Card
class UserCardPronounsBadge extends Component {
  @service site;

  get fieldName() {
    return settings.pronouns_field_name || "Pronomes";
  }

  get pronouns() {
    console.log("[v0] UserCardPronounsBadge - args:", this.args);
    console.log("[v0] UserCardPronounsBadge - outletArgs:", this.args.outletArgs);
    console.log("[v0] UserCardPronounsBadge - site service:", this.site);
    
    const user = this.args.outletArgs?.user;
    return this.getPronounsWithSite(user);
  }

  getPronounsWithSite(user) {
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
