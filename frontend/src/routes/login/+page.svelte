<script lang="ts">
	import { goto } from '$app/navigation';
	import { authStore, login } from '$lib/api';

	let email = '';
	let password = '';
	let errorMessage = '';
	let isLoading = false;

	async function handleLogin() {
		isLoading = true;
		errorMessage = '';
		const { success } = await login(email, password);

		if (success) {
			// After login, we want to redirect based on role.
			// We will build a component to handle this logic soon.
			// For now, just go to a temporary loading page.
			goto('/');
		} else {
			errorMessage = 'Login failed. Please check your email and password.';
		}
		isLoading = false;
	}
</script>

<div class="flex min-h-screen items-center justify-center bg-gray-50">
	<div class="w-full max-w-md space-y-8 rounded-lg bg-white p-10 shadow-lg">
		<div>
			<h2 class="mt-6 text-center text-3xl font-bold tracking-tight text-gray-900">
				Sign in to your account
			</h2>
		</div>
		<form class="mt-8 space-y-6" on:submit|preventDefault={handleLogin}>
			<div class="space-y-4 rounded-md shadow-sm">
				<div>
					<label for="email-address" class="sr-only">Email address</label>
					<input
						id="email-address"
						name="email"
						type="email"
						autocomplete="email"
						required
						bind:value={email}
						class="relative block w-full appearance-none rounded-md border border-gray-300 px-3 py-2 text-gray-900 placeholder-gray-500 focus:z-10 focus:border-indigo-500 focus:outline-none focus:ring-indigo-500 sm:text-sm"
						placeholder="Email address"
					/>
				</div>
				<div>
					<label for="password" class="sr-only">Password</label>
					<input
						id="password"
						name="password"
						type="password"
						autocomplete="current-password"
						required
						bind:value={password}
						class="relative block w-full appearance-none rounded-md border border-gray-300 px-3 py-2 text-gray-900 placeholder-gray-500 focus:z-10 focus:border-indigo-500 focus:outline-none focus:ring-indigo-500 sm:text-sm"
						placeholder="Password"
					/>
				</div>
			</div>

			{#if errorMessage}
				<p class="text-sm text-red-600">{errorMessage}</p>
			{/if}

			<div>
				<button
					type="submit"
					disabled={isLoading}
					class="group relative flex w-full justify-center rounded-md border border-transparent bg-indigo-600 px-4 py-2 text-sm font-medium text-white hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 disabled:bg-indigo-400"
				>
					{#if isLoading}
						Signing in...
					{:else}
						Sign in
					{/if}
				</button>
			</div>
		</form>
	</div>
</div>
