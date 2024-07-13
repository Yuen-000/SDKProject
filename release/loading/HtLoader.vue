<template>
  <div class="ht-loader">
    <div class="header">
      <a href="https://cloud.vket.com/" class="logo-link" target="_blank">
        <img :src="loaderLogo" class="logo" />
      </a>
      <!-- note: 直近では使用しない -->
      <!-- <a href="https://hikky.co.jp/" target="_blank" class="link">
        <span class="guide"> 広告主のサイトにアクセス </span>
        <img :src="blankLink" class="link-icon" />
      </a> -->
    </div>
    <!-- <component class="component" :is="showComponents" /> -->
    <HoLoaderParad v-show="isFetched" :thumbnail="worldThumbnail" :description="worldDescription"/>
    <div class="footer">
      <span class="note">
        {{ noteMessage }}
      </span>
    </div>
  </div>
</template>
<script setup>
import { ref, onBeforeMount } from "vue";
import HoLoaderParad from "./HoLoaderParad.vue";

// 共通的に必要な情報
// query にworldidがある場合は、そのworldidを使用する
const _worldIdByQuery = new URLSearchParams(window.top.location.search).get("worldid");
// query にworldidがない場合は、.*/worlds/がパスに含まれていれば、その次の階層のパスを使用する
const _worldIdByPath = window.top.location.pathname.match(/.*\/worlds\/([^/]+)/)?.[1];
const worldId = _worldIdByQuery || _worldIdByPath || undefined;

// World情報
const WORLD_DEFALT_TEXT = `Vket Cloud(ブイケットクラウド)は、あなたのメタバースサービスをブラウザで展開できる開発エンジンです。クリエイターからビジネス利用まで用途に合わせたプランをご利用ください。
Vket Cloud is a development engine that allows you to deploy your metaverse service in the browser. Please choose a plan that best suits your usage from creators to business use.`;
const WORLD_SPATIUM_CODE = "default";
const WORLD_PLATFORM_CODE = "myvket";
const worldDefaultThumbnailUrl = `https://cdn.vket.com/vketcloud/loading/default-parad-image.png`;
const loaderLogo = `https://cdn.vket.com/vketcloud/loading/loader-logo.svg`;
// const blankLink = `https://cdn.vket.com/vketcloud/loading/blank-link.svg`;

const worldDefaultDescription = WORLD_DEFALT_TEXT;
const worldThumbnail = ref(worldDefaultThumbnailUrl);
const worldDescription = ref(worldDefaultDescription);
const isFetched = ref(false);

const isLangJa = () => {
  const browserLang =
    (window.navigator.languages && window.navigator.languages[0]) ||
    window.navigator.language ||
    window.navigator.userLanguage ||
    window.navigator.browserLanguage;

  return browserLang === 'ja' || browserLang === 'ja-JP';
};
const noteMessage =  isLangJa() ? 'ロード完了まで画面を切り替えずそのままお待ちください。' : 'Please wait until the loading is complete.';

onBeforeMount(async () => {
  try {
    console.log("worldId", worldId)
    if (worldId) {
      const worldRes = await window.top.api.worlds.getWorldDetailByWorldId(WORLD_SPATIUM_CODE, worldId, WORLD_PLATFORM_CODE);
      const worldJson = JSON.parse(worldRes);
      worldThumbnail.value = worldJson?.world_portal?.thumbnail?.url || worldDefaultThumbnailUrl;
      worldDescription.value = worldJson?.world_portal?.description || worldDescription;
    }
  } catch (error) {
    console.error(error);
  } finally {
    isFetched.value = true;
  }
});

</script>
<style>
.ht-loader {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  overflow: hidden;
}
.ht-loader > .header {
  align-items: center;
  display: flex;
  justify-content: space-between;
  min-height: 3rem;
  gap: 1rem;
  > .link {
    align-items: center;
    display: flex;
    text-decoration: none;
    > .guide {
      color: #fff;
      font-size: 1rem;
      margin-right: 0.25rem;
    }
    > .link-icon {
      height: 1rem;
      width: 1rem;
    }
  }
}
.ht-loader > .component {
  width: 100%;
  max-height: -webkit-fill-available;
  overflow: hidden;
}
.ht-loader > .footer {
  align-items: center;
  display: flex;
  justify-content: center;
  min-height: 2rem;
  > .note {
    color: #fff;
    font-size: 0.75rem;
  }
}
@media (orientation: landscape) {
  .ht-loader > .header {
    padding: 0 0.5rem;
  }
}
@media (orientation: portrait) {
  .ht-loader > .header {
    padding: 0.25rem 0.5rem;
  }
}
</style>
