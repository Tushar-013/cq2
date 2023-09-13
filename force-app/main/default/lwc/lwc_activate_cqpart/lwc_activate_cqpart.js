import { LightningElement ,api, track, wire} from 'lwc';
import hasCQAdminPermissionSet from '@salesforce/apex/partActivationControllerAnchal.hasCQAdminPermissionSet';
import getRecordDetail from '@salesforce/apex/partActivationControllerAnchal.getRecordDetail';
import { getRecord } from 'lightning/uiRecordApi';
import ACTIVE from "@salesforce/schema/compliancequest__SQX_Part__c.compliancequest__Active__c";
import ID_FIELD from "@salesforce/schema/compliancequest__SQX_Part__c.Id";
import RREASON_FOR_CHANGE from "@salesforce/schema/compliancequest__SQX_Part__c.compliancequest__Reason_For_Change__c";

const FIELDS = ['compliancequest__SQX_Part__c.compliancequest__Reason_For_Change__c', 'compliancequest__SQX_Part__c.compliancequest__Active__c'];

export default class Lwc_activate_cqpart extends LightningElement {
    @api recordId;
    @track isCQAdmin = false;
    error;
    data;

    @wire(hasCQAdminPermissionSet)
    hasPermission({ error, data }) {
        
        if (data) {
            console.log(data);
        
            this.isCQAdmin = data;
            this.error = undefined;
        }
        else if (error) {
            console.log(error);
        
            this.toastEvent('error',error,'error');
            this.isCQAdmin = undefined;
        };
    }

    handleClick(){
        getContactList({recordID:this.recordId})
      .then((result) => {
        this.data = result;
      })
      .catch((error) => {
        this.error = error;
      });
      if(data.compliancequest__Reason_For_Change__c){
         const allValid = [...this.template.querySelectorAll("lightning-input")].reduce(
              (validSoFar, inputFields) => {
                inputFields.reportValidity();
                return validSoFar && inputFields.checkValidity();
              },
              true,
            );
        
            if (allValid) {
              // Create the recordInput object
              const fields = {};
              fields[ID_FIELD.fieldApiName] = this.recordId;
              fields[RREASON_FOR_CHANGE.RREASON_FOR_CHANGE] = this.template.querySelector(
                "[data-field='reasonForChange']",
              ).value;
              fields[ACTIVE.fieldApiName] = true;

              const recordInput = { fields };

        updateRecord(recordInput)
            .then(() => {
                this.toastEvent('Success!', 'Successfully Activated Account', 'Success');
            // Display fresh data in the form
            return refreshApex(this.recordId);
            })
            .catch((error) => {
                this.toastEvent('Error!',error.body.message,'error');
            });
        }
    }
    else{
        this.toastEvent('Error!','Plaese add Reason For Change','error');
    }
    }

    toastEvent(title, message, variant){
        this.dispatchEvent(new ShowToastEvent({title: title,message: message, variant: variant}));
    }

}