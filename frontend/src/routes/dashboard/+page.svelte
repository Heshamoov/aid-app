<script lang="ts">
	import { pb } from '$lib/api';
	import { onMount } from 'svelte';

	let familyCount = 0;
	let totalPeople = 0;
	let distributionCount = 0;

	onMount(async () => {
		// Fetch the total number of family records
		const familyResult = await pb.collection('families').getList(1, 1, {
			fields: 'id' // We only need the count, so we fetch minimal data
		});
		familyCount = familyResult.totalItems;

		// To get total people, we'd ideally have a dedicated API endpoint.
		// For now, we'll just show the family count as a placeholder for this metric.
		// A more advanced query would be needed to sum the 'familySize' field.
		totalPeople = familyCount; // Placeholder

		// Fetch the total number of distribution records
		const distributionResult = await pb.collection('distributions').getList(1, 1, {
			fields: 'id'
		});
		distributionCount = distributionResult.totalItems;
	});
</script>

<div class="py-10">
	<header>
		<div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
			<h1 class="text-3xl font-bold leading-tight tracking-tight text-gray-900">Dashboard</h1>
		</div>
	</header>
	<main>
		<div class="mx-auto max-w-7xl sm:px-6 lg:px-8">
			<div class="px-4 py-8 sm:px-0">
				<!-- Key Metric Cards -->
				<div class="grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-3">
					<!-- Total Families Card -->
					<div class="overflow-hidden rounded-lg bg-white shadow">
						<div class="p-5">
							<div class="flex items-center">
								<div class="ml-5 w-0 flex-1">
									<dl>
										<dt class="truncate text-sm font-medium text-gray-500">
											Total Families Registered
										</dt>
										<dd>
											<div class="text-3xl font-bold text-gray-900">{familyCount}</div>
										</dd>
									</dl>
								</div>
							</div>
						</div>
					</div>
					<!-- Add this new card for viewing submissions -->
					<div class="overflow-hidden rounded-lg bg-white shadow">
						<div class="p-5">
							<div class="flex items-center">
								<div class="ml-5 w-0 flex-1">
									<dl>
										<dt class="truncate text-sm font-medium text-gray-500">View Data</dt>
										<dd>
											<a
												href="/dashboard/submissions"
												class="text-3xl font-bold text-teal-600 hover:text-teal-700"
											>
												View Submissions
											</a>
										</dd>
									</dl>
								</div>
							</div>
						</div>
					</div>

					<!-- Total People Assisted Card -->
					<div class="overflow-hidden rounded-lg bg-white shadow">
						<div class="p-5">
							<div class="flex items-center">
								<div class="ml-5 w-0 flex-1">
									<dl>
										<dt class="truncate text-sm font-medium text-gray-500">
											Total People Assisted (Placeholder)
										</dt>
										<dd>
											<div class="text-3xl font-bold text-gray-900">{totalPeople}</div>
										</dd>
									</dl>
								</div>
							</div>
						</div>
					</div>

					<!-- Distributions Card -->
					<div class="overflow-hidden rounded-lg bg-white shadow">
						<div class="p-5">
							<div class="flex items-center">
								<div class="ml-5 w-0 flex-1">
									<dl>
										<dt class="truncate text-sm font-medium text-gray-500">Total Distributions</dt>
										<dd>
											<div class="text-3xl font-bold text-gray-900">{distributionCount}</div>
										</dd>
									</dl>
								</div>
							</div>
						</div>
					</div>
					<!-- Inside the grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-3 div -->
					<!-- Add this new card -->
					<div class="overflow-hidden rounded-lg bg-white shadow">
						<div class="p-5">
							<div class="flex items-center">
								<div class="ml-5 w-0 flex-1">
									<dl>
										<dt class="truncate text-sm font-medium text-gray-500">Form Builder</dt>
										<dd>
											<a
												href="/dashboard/forms"
												class="text-3xl font-bold text-indigo-600 hover:text-indigo-700"
											>
												Manage Forms
											</a>
										</dd>
									</dl>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</main>
</div>
