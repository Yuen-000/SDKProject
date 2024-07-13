<template>
  <div class="ho-loader-parad">
    <div class="image-box">
      <img class="image" :src="thumbnail" />
    </div>
    <div class="description-box">
      <p class="description">{{ description }}</p>
    </div>
  </div>
</template>
<script setup>
import { defineProps } from "vue";
defineProps({
  thumbnail: {
    type: String,
  },
  description: {
    type: String,
  },
});

</script>
<style>
.ho-loader-parad {
  width: 100%;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  position: relative;
}
.image-box {
  aspect-ratio: 16 / 9;
  > .image {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }
}
.description-box {
  padding: 1rem;
  background-color: rgba(255, 255, 255, 0.07);
  flex: 1;
  overflow: hidden;
  width: auto;
  min-width: -webkit-fill-available;
  max-width: 100%;
  > .description {
    color: #fff;
    font-size: 1rem;
    line-height: 1.5rem;
    max-height: 100%;
    overflow: hidden;
    overflow-wrap: break-word;
    letter-spacing: 0.05rem;
    text-overflow: ellipsis;
    white-space: pre-wrap;
    margin: 0;
    word-break: break-all;
  }
}
@media (orientation: landscape) {
  .image-box {
    height: 100%;
    width: auto;
  }
  .description-box {
    position: absolute;
    height: 4rem;
    bottom: 0;
    padding: 0.5rem 1rem;
    background: rgba(25, 25, 25, 0.7);
    backdrop-filter: blur(3.5px);
    > .description {
      display: -webkit-box;
      -webkit-box-orient: vertical;
      line-height: 1.25rem;
      white-space: inherit;
      -webkit-line-clamp: 3;
    }
  }
}
@media (orientation: portrait) {
  .image-box {
    height: auto;
    width: 100%;
  }
  .description-box {
    > .description {
      overflow-y: auto;
    }
  }
}
</style>
