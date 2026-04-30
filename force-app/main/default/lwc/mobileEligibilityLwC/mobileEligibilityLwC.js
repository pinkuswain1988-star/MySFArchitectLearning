import { LightningElement } from 'lwc';

export default class MobileEligibilityLwC extends LightningElement {
    mobileNumber = '';
    message = '';

    handleChange(event){
        this.mobileNumber = event.target.value;
    }

    handleClick(event){
        if(this.mobileNumber.startsWith('021')){
            this.message = 'Eligible for eSIM Transfer';
        }
        else{
            this.message = 'Not Eligible';
        }
    }
}