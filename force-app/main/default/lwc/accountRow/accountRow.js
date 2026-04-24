import { LightningElement , api } from 'lwc';

export default class AccountRow extends LightningElement {
    @api account;

    handleClick(){
        console.log('Child click:', this.account.Id);
        this.dispatchEvent(
            new CustomEvent('createorder', {
                detail: {
                    accountId: this.account.Id
                }
            })
        );
    }
}