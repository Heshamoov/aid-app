<script lang="ts">
	import { pb } from '$lib/api';
	import { onMount } from 'svelte';

	let submissionCount = 0;
	let formCount = 0;

	// Financial data
	let totalIncome = 0;
	let totalExpenses = 0;
	let currentBalance = 0;
	let recentTransactions = [];

	onMount(async () => {
		// Fetch the total number of form records
		try {
			const formResult = await pb.collection('forms').getList(1, 1, {
				fields: 'id'
			});
			formCount = formResult.totalItems;
		} catch (error) {
			console.error('Error fetching forms:', error);
			formCount = 0;
		}

		// Fetch the total number of submission records
		try {
			const submissionResult = await pb.collection('submissions').getList(1, 1, {
				fields: 'id'
			});
			submissionCount = submissionResult.totalItems;
		} catch (error) {
			console.error('Error fetching submissions:', error);
			submissionCount = 0;
		}

		// Fetch financial data
		await fetchFinancialData();
	});

	async function fetchFinancialData() {
		try {
			// Fetch all donations
			const donationsResult = await pb.collection('donations').getFullList({
				fields: 'amount,currency'
			});

			// Calculate total income (assuming USD for now, would need currency conversion in real app)
			totalIncome = donationsResult.reduce((sum, donation) => sum + donation.amount, 0);

			// Fetch all approved expenses
			const expensesResult = await pb.collection('expenses').getFullList({
				filter: 'status = "Approved"',
				fields: 'amount,currency'
			});

			// Calculate total expenses
			totalExpenses = expensesResult.reduce((sum, expense) => sum + expense.amount, 0);

			// Calculate current balance
			currentBalance = totalIncome - totalExpenses;

			// Fetch recent transactions (last 5 donations and expenses)
			const recentDonations = await pb.collection('donations').getList(1, 3);
			console.log('recentDonations sample:', recentDonations.items[0]);

			const recentExpenses = await pb.collection('expenses').getList(1, 3);

			// Combine and sort recent transactions
			recentTransactions = [
				...recentDonations.items.map((d) => ({
					type: 'donation',
					description: `Donation from ${d.donor_name}`,
					amount: d.amount,
					currency: d.currency,
					date: d.created
				})),
				...recentExpenses.items.map((e) => ({
					type: 'expense',
					description: e.description,
					amount: e.amount,
					currency: e.currency,
					date: e.created,
					category: e.category
				}))
			]
				.sort((a, b) => new Date(b.date).getTime() - new Date(a.date).getTime())
				.slice(0, 5);
		} catch (error) {
			console.error('Error fetching financial data:', error);
			// Set default values if collections don't exist yet
			totalIncome = 0;
			totalExpenses = 0;
			currentBalance = 0;
			recentTransactions = [];
		}
	}
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
				<!-- Financial Summary Section -->
				<div class="mb-8">
					<h2 class="mb-4 text-xl font-semibold text-gray-900">Financial Overview</h2>
					<div class="grid grid-cols-1 gap-5 sm:grid-cols-3">
						<!-- Total Income Card -->
						<div class="overflow-hidden rounded-lg bg-green-50 shadow">
							<div class="p-5">
								<div class="flex items-center">
									<div class="flex-shrink-0">
										<svg
											class="h-8 w-8 text-green-600"
											fill="none"
											stroke="currentColor"
											viewBox="0 0 24 24"
										>
											<path
												stroke-linecap="round"
												stroke-linejoin="round"
												stroke-width="2"
												d="M12 6v12m-3-2.818l.879.659c1.171.879 3.07.879 4.242 0 1.172-.879 1.172-2.303 0-3.182C13.536 12.219 12.768 12 12 12c-.725 0-1.45-.22-2.003-.659-1.106-.879-1.106-2.303 0-3.182s2.9-.879 4.006 0l.415.33M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
											></path>
										</svg>
									</div>
									<div class="ml-5 w-0 flex-1">
										<dl>
											<dt class="truncate text-sm font-medium text-gray-500">Total Income</dt>
											<dd>
												<div class="text-2xl font-bold text-green-900">
													${totalIncome.toLocaleString()}
												</div>
											</dd>
										</dl>
									</div>
								</div>
							</div>
						</div>

						<!-- Total Expenses Card -->
						<div class="overflow-hidden rounded-lg bg-red-50 shadow">
							<div class="p-5">
								<div class="flex items-center">
									<div class="flex-shrink-0">
										<svg
											class="h-8 w-8 text-red-600"
											fill="none"
											stroke="currentColor"
											viewBox="0 0 24 24"
										>
											<path
												stroke-linecap="round"
												stroke-linejoin="round"
												stroke-width="2"
												d="M17 9V7a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2m2 4h10a2 2 0 002-2v-6a2 2 0 00-2-2H9a2 2 0 00-2 2v6a2 2 0 002 2zm7-5a2 2 0 11-4 0 2 2 0 014 0z"
											></path>
										</svg>
									</div>
									<div class="ml-5 w-0 flex-1">
										<dl>
											<dt class="truncate text-sm font-medium text-gray-500">Total Expenses</dt>
											<dd>
												<div class="text-2xl font-bold text-red-900">
													${totalExpenses.toLocaleString()}
												</div>
											</dd>
										</dl>
									</div>
								</div>
							</div>
						</div>

						<!-- Current Balance Card -->
						<div class="overflow-hidden rounded-lg bg-blue-50 shadow">
							<div class="p-5">
								<div class="flex items-center">
									<div class="flex-shrink-0">
										<svg
											class="h-8 w-8 text-blue-600"
											fill="none"
											stroke="currentColor"
											viewBox="0 0 24 24"
										>
											<path
												stroke-linecap="round"
												stroke-linejoin="round"
												stroke-width="2"
												d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"
											></path>
										</svg>
									</div>
									<div class="ml-5 w-0 flex-1">
										<dl>
											<dt class="truncate text-sm font-medium text-gray-500">Current Balance</dt>
											<dd>
												<div
													class="text-2xl font-bold {currentBalance >= 0
														? 'text-blue-900'
														: 'text-red-900'}"
												>
													${currentBalance.toLocaleString()}
												</div>
											</dd>
										</dl>
									</div>
								</div>
							</div>
						</div>
					</div>

					<!-- Financial Management Button -->
					<div class="mt-4">
						<a
							href="/dashboard/finances"
							class="inline-flex items-center rounded-md border border-transparent bg-indigo-600 px-4 py-2 text-sm font-medium text-white shadow-sm hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
						>
							<svg class="mr-2 h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
								<path
									stroke-linecap="round"
									stroke-linejoin="round"
									stroke-width="2"
									d="M9 7h6m0 10v-3m-3 3h.01M9 17h.01M9 14h.01M12 14h.01M15 11h.01M12 11h.01M9 11h.01M7 21h10a2 2 0 002-2V5a2 2 0 00-2-2H7a2 2 0 00-2 2v14a2 2 0 002 2z"
								></path>
							</svg>
							Manage Finances
						</a>
					</div>
				</div>

				<!-- Key Metric Cards -->
				<div class="mb-8">
					<h2 class="mb-4 text-xl font-semibold text-gray-900">Operations Overview</h2>
					<div class="grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-3">
						<!-- Total Forms Card -->
						<div class="overflow-hidden rounded-lg bg-white shadow">
							<div class="p-5">
								<div class="flex items-center">
									<div class="ml-5 w-0 flex-1">
										<dl>
											<dt class="truncate text-sm font-medium text-gray-500">
												Total Forms Created
											</dt>
											<dd>
												<div class="text-3xl font-bold text-gray-900">{formCount}</div>
											</dd>
										</dl>
									</div>
								</div>
							</div>
						</div>

						<!-- Total Submissions Card -->
						<div class="overflow-hidden rounded-lg bg-white shadow">
							<div class="p-5">
								<div class="flex items-center">
									<div class="ml-5 w-0 flex-1">
										<dl>
											<dt class="truncate text-sm font-medium text-gray-500">Total Submissions</dt>
											<dd>
												<div class="text-3xl font-bold text-gray-900">{submissionCount}</div>
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
		</div>
	</main>
</div>
