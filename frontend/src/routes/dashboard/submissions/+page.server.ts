// src/routes/app/dashboard/submissions/+page.server.ts
import type { PageServerLoad } from './$types';
import { error } from '@sveltejs/kit';

export const load: PageServerLoad = async ({ locals }) => {
	console.log('locals.user:', locals.user); // Debug line
	// Block non-admins
	if (!locals.user || locals.user.role !== 'admin') {
		throw error(403, 'Not authorized');
	}

	const submissions = await locals.pb.collection('submissions').getFullList({
		sort: '-created',
		expand: 'form,submittedBy'
	});

	return { submissions };
};
