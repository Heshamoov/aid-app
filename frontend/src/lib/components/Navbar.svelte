<script lang="ts">
	import { authStore, logout } from '$lib/api';
	import { goto } from '$app/navigation';
	// Add this function
	function handleLogout() {
		logout();
		goto('/login');
	}
</script>

<nav class="bg-white shadow-md">
	<div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
		<div class="flex h-16 justify-between">
			<div class="flex items-center">
				<p class="text-lg font-bold text-indigo-600">Aid Platform</p>
			</div>
			<div class="flex items-center">
				{#if $authStore.user}
					<span class="mr-4 text-sm text-gray-500">{$authStore.user.email}</span>
					<button
						on:click={handleLogout}
						class="rounded-md bg-red-500 px-3 py-1 text-sm font-medium text-white hover:bg-red-600"
					>
						Logout
					</button>
				{/if}
			</div>
		</div>
	</div>
</nav>
