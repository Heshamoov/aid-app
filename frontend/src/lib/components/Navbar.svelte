<script lang="ts">
  import { authStore, logout } from '$lib/api';
  import { goto } from '$app/navigation';
  import { t, locale } from 'svelte-i18n';
  import { browser } from '$app/environment';

  function handleLogout() {
    logout();
    goto('/login');
  }

  function switchTo(lang: 'en' | 'ar') {
    locale.set(lang);
    if (browser) localStorage.setItem('lang', lang); // keep choice after reload
  }

  $: current = $locale === 'ar' ? 'ar' : 'en';
</script>

<nav class="bg-white shadow-md">
  <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
    <div class="flex h-16 items-center justify-between">
      <!-- Left: Brand + sample i18n text -->
      <div class="flex items-center gap-4">
        <p class="text-lg font-bold text-indigo-600">{$t('title')}</p>
        <h1 class="text-xl font-semibold">{$t('welcome-message')}</h1>
      </div>

      <!-- Right: Lang switcher + user -->
      <div class="flex items-center gap-4">
        <!-- Language Switcher (compact pill) -->
        <div
          class="inline-flex rounded-full border bg-white p-1 shadow-sm"
          role="group"
          aria-label="Language switcher"
        >
          <button
            type="button"
            class="px-3 py-1.5 text-sm rounded-full transition
                   focus:outline-none focus-visible:ring
                   {current === 'en' ? 'bg-gray-900 text-white' : 'hover:bg-gray-100'}"
            aria-pressed={current === 'en'}
            on:click={() => switchTo('en')}
          >
            English
          </button>
          <button
            type="button"
            class="px-3 py-1.5 text-sm rounded-full transition
                   focus:outline-none focus-visible:ring
                   {current === 'ar' ? 'bg-gray-900 text-white' : 'hover:bg-gray-100'}"
            aria-pressed={current === 'ar'}
            on:click={() => switchTo('ar')}
          >
            عربي
          </button>
        </div>

        {#if $authStore.user}
          <span class="hidden sm:inline text-sm text-gray-500">{$authStore.user.email}</span>
          <button
            on:click={handleLogout}
            class="rounded-md bg-red-500 px-3 py-1 text-sm font-medium text-white hover:bg-red-600"
          >
            {$t('logout')}
          </button>
        {/if}
      </div>
    </div>
  </div>
</nav>
