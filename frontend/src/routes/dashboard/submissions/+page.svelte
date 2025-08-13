<script lang="ts">
	export let data: { submissions: any[] };
</script>

<h1>Form Submissions</h1>

{#if !data.submissions.length}
	<p>No data has been submitted yet.</p>
{:else}
	<table>
		<thead>
			<tr><th>Form</th><th>Submitted By</th></tr>
		</thead>
		<tbody>
			{#each data.submissions as sub}
				<tr>
					<td>{sub.expand?.form?.name}</td>
					<td>{sub.expand?.submittedBy?.email}</td>
				</tr>
			{/each}
		</tbody>
	</table>
{/if}
