import { LightningElement, wire } from 'lwc';
import getAccounts from '@salesforce/apex/AccountLwcController.getAccounts';
import triggerOrder from '@salesforce/apex/AccountLwcController.triggerOrder';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AccountWireDemo extends LightningElement {
    accounts = [];
    isLoading = true;
    errorMessage = '';

    @wire(getAccounts)
    wiredAccounts({ data, error }) {
        this.isLoading = false;

        if (data) {
            this.accounts = data.map(acc => ({
                ...acc,
                    isDisabled: false
                }));
        } else if (error) {
            this.errorMessage = 'Failed to load accounts';
        }
    }

    handleClick(event) {
    const accountId = event.target.dataset.id;

    // Disable clicked button
    this.accounts = this.accounts.map(acc =>
        acc.Id === accountId ? { ...acc, isDisabled: true } : acc
    );

    triggerOrder({ accountId })
        .then(result => {
            this.showToast('Success', result, 'success');
        })
        .catch(error => {
            this.showToast('Error', 'Failed to create order', 'error');

            // Re-enable on failure
            this.accounts = this.accounts.map(acc =>
                acc.Id === accountId ? { ...acc, isDisabled: false } : acc
            );
        });
    }

    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title,
                message,
                variant
            })
        );
    }
}