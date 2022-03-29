pageextension 50090 "Company Information Ext ITB" extends 1
{
    layout
    {
        // Add changes to page layout here
        addafter("Payments")
        {
            group("Betalinger FIK")
            {
                field("FIK Bank Creditor No."; "FIK Bank Creditor No.")
                {
                    ApplicationArea = All;
                }
            }
        }

        addafter(IBAN)
        {
            field(Iban02; Iban02)
            {
                ApplicationArea = All;
            }
            field(Swift02; Swift02)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}