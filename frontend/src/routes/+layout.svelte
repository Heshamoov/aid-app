<script lang="ts">
    // Import the global stylesheet
    import '../app.css'; 
    
    // Import the navigation bar component
    import Navbar from '$lib/components/Navbar.svelte';
</script>

<div class="min-h-screen bg-gray-100">
    <Navbar />
    <main>
        <slot />
    </main>
</div>
