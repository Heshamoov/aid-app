<script lang="ts">
	import { authStore } from '$lib/api';
	import { goto } from '$app/navigation';
	import { onMount } from 'svelte';

	onMount(() => {
		// A short delay helps ensure the authStore is updated after a quick login redirect
		setTimeout(() => {
			// @ts-ignore - We added a custom 'get' method to the store in api.ts
			const store = authStore.get();
			const user = store.user;

			if (user) {
				// User is logged in, redirect based on role
				console.log('User found, redirecting based on role:', user.role);
				const role = user.role;
				if (role === 'admin' || role === 'monitor') {
					goto('/dashboard', { replaceState: true });
				} else if (role === 'volunteer') {
					goto('/volunteer', { replaceState: true });
				} else {
					// Fallback for users with no role
					goto('/login', { replaceState: true });
				}
			} else {
				// User is not logged in, send to login page
				console.log('No user found, redirecting to /login');
				goto('/login', { replaceState: true });
			}
		}, 50);
	});
</script>

<div class="flex min-h-screen items-center justify-center">
	<p class="text-lg">Loading...</p>
</div>

