import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  toggle = async (event) => {
    event.preventDefault();
    
    const form = event.target.closest('form');
    if (!form) return;
    
    const button = form.querySelector('button');
    const icon = button.querySelector('i');
    const originalHTML = button.innerHTML;
    
    // Show loading state
    button.disabled = true;
    icon.className = 'fas fa-spinner fa-spin';
    
    try {
      const response = await fetch(form.action, {
        method: form.method,
        headers: {
          'Accept': 'application/json',
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
        },
        body: new FormData(form)
      });
      
      const result = await response.json();
      
      if (response.ok) {
        if (result.status === 'favorited') {
          // Switch to unfavorite button
          button.className = 'button is-small is-danger';
          button.title = button.dataset.removeTitle || 'Remove from favorites';
          icon.className = 'fas fa-heart';
          form.action = form.action.replace('/favorites', '/favorites/' + result.id);
          form.method = 'POST';
          const methodInput = form.querySelector('input[name="_method"]');
          if (methodInput) {
            methodInput.value = 'delete';
          } else {
            const deleteMethod = document.createElement('input');
            deleteMethod.type = 'hidden';
            deleteMethod.name = '_method';
            deleteMethod.value = 'delete';
            form.appendChild(deleteMethod);
          }
        } else if (result.status === 'unfavorited') {
          // Switch to favorite button
          button.className = 'button is-small is-light';
          button.title = button.dataset.addTitle || 'Add to favorites';
          icon.className = 'far fa-heart';
          form.action = form.action.replace(/\/favorites\/\d+/, '/favorites');
          form.method = 'POST';
          const methodInput = form.querySelector('input[name="_method"]');
          if (methodInput) {
            methodInput.remove();
          }
        }
        
        // Show flash message if needed
        if (result.message) {
          this.showFlashMessage(result.message, 'success');
        }
      } else {
        // Show error message
        if (result.message) {
          this.showFlashMessage(result.message, 'error');
        }
        // Restore original button state
        button.innerHTML = originalHTML;
      }
    } catch (error) {
      console.error('Favorite toggle error:', error);
      let errorMessage = 'An error occurred. Please try again.';
      if (!navigator.onLine) {
        errorMessage = 'Please check your internet connection.';
      }
      this.showFlashMessage(errorMessage, 'error');
      // Restore original button state
      button.innerHTML = originalHTML;
    } finally {
      button.disabled = false;
    }
  };
  
  showFlashMessage = (message, type) => {
    // Create flash message element
    const flash = document.createElement('div');
    flash.className = `notification ${type === 'success' ? 'is-success' : 'is-danger'} is-light`;
    flash.innerHTML = `
      <button class="delete" onclick="this.parentElement.remove()"></button>
      ${message}
    `;
    
    // Add to page (look for existing flash container or create one)
    let flashContainer = document.querySelector('.flash-messages');
    if (!flashContainer) {
      flashContainer = document.createElement('div');
      flashContainer.className = 'flash-messages';
      document.body.insertBefore(flashContainer, document.body.firstChild);
    }
    
    flashContainer.appendChild(flash);
    
    // Auto-remove after 3 seconds
    setTimeout(() => {
      flash.remove();
    }, 3000);
  };
}