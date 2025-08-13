<script lang="ts">
	import { pb } from '$lib/api';
	import { onMount } from 'svelte';

	let forms: any[] = [];
	let newFormName = '';
	let newFormDescription = '';
	let selectedForm: any = null;
	let newQuestionText = '';
	let newQuestionType = 'Text';
	let newQuestionChoices = '';
	let newQuestionIsRequired = true;

	onMount(async () => {
		await fetchForms();
	});

	async function fetchForms() {
		try {
			const result = await pb.collection('forms').getFullList({
				sort: '-created'
			});
			forms = result;
		} catch (error) {
			console.error('Error fetching forms:', error);
		}
	}

	async function createForm() {
		if (!newFormName) return;
		try {
			await pb.collection('forms').create({
				formName: newFormName,
				description: newFormDescription,
				createdBy: pb.authStore.model?.id, // Link to the current admin user
				isActive: true // <--- ADD THIS LINE
			});
			newFormName = '';
			newFormDescription = '';
			await fetchForms();
		} catch (error) {
			console.error('Error creating form:', error);
		}
	}

	async function addQuestion() {
		if (!selectedForm || !newQuestionText) return;

		// ... inside addQuestion ...
		const data = {
			form: selectedForm.id,
			questionText: newQuestionText,
			questionType: newQuestionType,
			isRequired: newQuestionIsRequired,
			order: selectedForm.questions ? selectedForm.questions.length : 0,
			// CORRECTED: Send null if not Single-Choice, or parse the JSON string
			choices: newQuestionType === 'Single-Choice' ? JSON.parse(newQuestionChoices || '[]') : null
		};
		// ...

		try {
			// Create the new question record in the database
			await pb.collection('questions').create(data);

			// Reset the form fields
			newQuestionText = '';
			newQuestionType = 'Text';
			newQuestionChoices = '';
			newQuestionIsRequired = true;

			// Refresh the list of questions for the currently selected form
			await selectForm(selectedForm);
		} catch (error) {
			console.error('Error adding question:', error);
			// Log the detailed validation errors from PocketBase
			if (error.data && error.data.data) {
				console.error('PocketBase validation errors:', error.data.data);
				alert('PocketBase Error: ' + JSON.stringify(error.data.data));
			} else {
				alert('An unknown error occurred. Check the console.');
			}
		}
	}

	async function selectForm(form: any) {
		selectedForm = form;
		if (selectedForm) {
			try {
				// Fetch questions for the selected form
				const questionsList = await pb.collection('questions').getFullList({
					// NEW APPROACH: Use the 'query' object for filtering
					query: {
						filter: `form = '${selectedForm.id}'`
					},
					sort: 'order'
				});
				selectedForm.questions = questionsList;
			} catch (error) {
				console.error('Error fetching questions for form:', error);
				selectedForm.questions = [];
			}
		}
	}
</script>

<div class="mx-auto max-w-7xl px-4 py-10 sm:px-6 lg:px-8">
	<h1 class="mb-6 text-3xl font-bold text-gray-900">Form Builder</h1>

	<!-- Create New Form Section -->
	<div class="mb-8 rounded-lg bg-white p-6 shadow">
		<h2 class="mb-4 text-xl font-semibold text-gray-800">Create New Form</h2>
		<div class="mb-4">
			<label for="formName" class="block text-sm font-medium text-gray-700">Form Name</label>
			<input
				type="text"
				id="formName"
				bind:value={newFormName}
				class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
			/>
		</div>
		<div class="mb-4">
			<label for="formDescription" class="block text-sm font-medium text-gray-700"
				>Description</label
			>
			<textarea
				id="formDescription"
				bind:value={newFormDescription}
				class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
			></textarea>
		</div>
		<button
			on:click={createForm}
			class="inline-flex items-center rounded-md border border-transparent bg-indigo-600 px-4 py-2 text-sm font-medium text-white shadow-sm hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
		>
			Create Form
		</button>
	</div>

	<!-- Existing Forms List -->
	<div class="mb-8 rounded-lg bg-white p-6 shadow">
		<h2 class="mb-4 text-xl font-semibold text-gray-800">Existing Forms</h2>
		{#if forms.length === 0}
			<p class="text-gray-600">No forms created yet.</p>
		{:else}
			<ul class="divide-y divide-gray-200">
				{#each forms as form (form.id)}
					<li class="flex items-center justify-between py-4">
						<div>
							<p class="text-lg font-medium text-gray-900">{form.formName}</p>
							<p class="text-sm text-gray-500">{form.description}</p>
						</div>
						<button
							on:click={() => selectForm(form)}
							class="rounded-md border border-gray-300 bg-white px-3 py-2 text-sm font-medium text-gray-700 shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
						>
							{selectedForm && selectedForm.id === form.id ? 'Selected' : 'Select'}
						</button>
					</li>
				{/each}
			</ul>
		{/if}
	</div>

	<!-- Add Questions to Selected Form Section -->
	{#if selectedForm}
		<div class="rounded-lg bg-white p-6 shadow">
			<h2 class="mb-4 text-xl font-semibold text-gray-800">
				Add Questions to "{selectedForm.formName}"
			</h2>

			<!-- Current Questions List -->
			<div class="mb-6">
				<h3 class="mb-2 text-lg font-medium text-gray-700">Current Questions</h3>
				{#if selectedForm.questions && selectedForm.questions.length > 0}
					<ul class="list-disc pl-5 text-gray-600">
						{#each selectedForm.questions as question (question.id)}
							<li>
								{question.questionText} (Type: {question.questionType})
								{#if question.questionType === 'Single-Choice'}
									- Choices: {JSON.stringify(question.choices)}
								{/if}
								{#if question.isRequired}
									(Required){/if}
							</li>
						{/each}
					</ul>
				{:else}
					<p class="text-gray-600">No questions added to this form yet.</p>
				{/if}
			</div>

			<!-- Add New Question Form -->
			<div class="mb-4">
				<label for="questionText" class="block text-sm font-medium text-gray-700"
					>Question Text</label
				>
				<input
					type="text"
					id="questionText"
					bind:value={newQuestionText}
					class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
				/>
			</div>
			<div class="mb-4">
				<label for="questionType" class="block text-sm font-medium text-gray-700"
					>Question Type</label
				>
				<select
					id="questionType"
					bind:value={newQuestionType}
					class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
				>
					<option>Text</option>
					<option>Number</option>
					<option>Yes/No</option>
					<option>Single-Choice</option>
				</select>
			</div>
			{#if newQuestionType === 'Single-Choice'}
				<div class="mb-4">
					<label for="questionChoices" class="block text-sm font-medium text-gray-700"
						>Choices (JSON Array, e.g., ["Option 1", "Option 2"])</label
					>
					<input
						type="text"
						id="questionChoices"
						bind:value={newQuestionChoices}
						class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
					/>
				</div>
			{/if}
			<div class="mb-4 flex items-center">
				<input
					id="isRequired"
					type="checkbox"
					bind:checked={newQuestionIsRequired}
					class="h-4 w-4 rounded border-gray-300 text-indigo-600 focus:ring-indigo-500"
				/>
				<label for="isRequired" class="ml-2 block text-sm text-gray-900">Required</label>
			</div>
			<button
				on:click={addQuestion}
				class="inline-flex items-center rounded-md border border-transparent bg-green-600 px-4 py-2 text-sm font-medium text-white shadow-sm hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-green-500 focus:ring-offset-2"
			>
				Add Question
			</button>
		</div>
	{/if}
</div>
