import { LightningElement , wire} from 'lwc';
import getAccounts from '@salesforce/apex/AccountOrderLwcController.getAccounts';
import createOrder from '@salesforce/apex/AccountOrderLwcController.createOrder';
import getOrderStatus from '@salesforce/apex/AccountOrderLwcController.getOrderStatus';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class AccountList extends LightningElement {
    accounts=[];
    errorMessage;

    @wire(getAccounts)
    fetchAccounts({ data, error }){
        if(data){
            this.accounts = data.map(acct => {
            return {
                ...acct,
                isLoading: false,
                isDisabled: false,
                statusMessage: '',
                buttonLabel: 'Create Order'
                };
            });
        }
        else if(error){
            this.errorMessage = 'Failed to load accounts';
            this.accounts = [];
            console.error(error);
        }
        }

async handleCreateOrder(event) {
    const accountId = event.detail.accountId;

    this.updateRowState(accountId, {
        isLoading: true,
        isDisabled: true,
        statusMessage: 'Processing...'
    });

    try {
        const correlationId = await createOrder({ accountId });

        this.startPolling(accountId, correlationId);

    } catch (error) {
        this.updateRowState(accountId, {
            isLoading: false,
            isDisabled: false,
            statusMessage: 'Failed ❌'
        });
    }
}  

    updateRowState(accountId, updates) {
    this.accounts = this.accounts.map(acc => {
        if (acc.Id === accountId) {
            return {
                ...acc,
                ...updates
            };
            }
        return acc;
        });
    }

    startPolling(accountId, correlationId) {

    const interval = setInterval(async () => {
        const status = await getOrderStatus({ correlationId });

        console.log('Status:', status);

        if (status === 'Completed') {
            clearInterval(interval);

            this.updateRowState(accountId, {
                isLoading: false,
                isDisabled: true,
                statusMessage: 'Order Created ✔️'
            });
        }

        if (status === 'Failed') {
            clearInterval(interval);

            this.updateRowState(accountId, {
                isLoading: false,
                isDisabled: false,
                statusMessage: 'Failed ❌'
            });
        }

    }, 2000);
}
}