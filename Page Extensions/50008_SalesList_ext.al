pageextension 50008 OrderList_REP_Ext extends "Sales Order List"
{
    layout
    {



    }

    actions
    {


        addlast(processing)
        {

            action(PakkelisteREP)
            {
                ApplicationArea = All;
                Caption = 'Pakkeliste';
                Image = CreatePutawayPick;
                Promoted = true;

                trigger OnAction()
                var
                    //cod: Codeunit "FS Export";
                    head: Record "Sales Header"; //her
                    Hline: Record "Sales Line";

                    TempSalesHead: Record "Sales Header";  // temporary;
                    TempSalesLine: Record "Sales Line";  // temporary;
                    HeaderOK: Boolean;
                    LineNo: integer;
                    Pick: Report "Sales_Samle_Pack ITB";    //"Pick Instruction";  //"Standard Sales - Order Conf.";
                    SalNum: Code[20];
                    ItemVar: Record Item;  //300522

                begin
                    //her
                    CurrPage.SetSelectionFilter(head);
                    //head.SetRange(Approve, Approve::Accepter);//

                    LineNo := 10000;
                    if head.FindSet then
                        repeat
                            //050522 cod."Create Sales_from_eSales"(head);
                            //head.Mark(false);
                            if HeaderOK = false then begin
                                TempSalesHead := head;
                                TempSalesHead."No." := 'S' + TempSalesHead."No.";
                                TempSalesHead.Insert;

                                HeaderOK := true;
                                SalNum := TempSalesHead."No.";

                            end;

                            Hline.Reset;
                            Hline.SetRange("Document No.", head."No.");
                            if Hline.FindSet then
                                repeat
                                    //300522
                                    Clear(ItemVar);
                                    ItemVar.Reset;
                                    ItemVar.SetRange("No.", Hline."No.");
                                    if ItemVar.FindSet then begin
                                        if ItemVar.Type = ItemVar.Type::Inventory then begin
                                            //300522

                                            TempSalesLine.reset;
                                            TempSalesLine.Init;
                                            TempSalesLine := Hline;
                                            TempSalesLine."Document No." := SalNum;
                                            TempSalesLine."Line No." := LineNo;
                                            TempSalesLine.LineReference := head."External Document No.";  //160522
                                            TempSalesLine.Insert;

                                            LineNo := LineNo + 10000;
                                        end;
                                    end;
                                until Hline.Next = 0;

                        until head.Next() = 0;

                    Commit;

                    //050522 - Her kaldes rapporten
                    Clear(TempSalesHead);
                    TempSalesHead.Reset;
                    TempSalesHead.SetRange("No.", SalNum);
                    if TempSalesHead.FindSet then begin
                        CLEAR(Pick);
                        Pick.SETTABLEVIEW(TempSalesHead);
                        //Pick.SetProformaInvoice;
                        Pick.RUN;

                    end;

                    // delete old - after use
                    //DeleteTempSales();


                    CLEAR(TempSalesHead);


                    TempSalesHead.SETRANGE(TempSalesHead."No.", SalNum);
                    TempSalesHead.DELETEALL;
                    CLEAR(TempSalesLine);
                    TempSalesLine.SETRANGE(TempSalesLine."Document No.", SalNum);
                    TempSalesLine.DELETEALL;



                    //her
                    //cod."Create Sales_from_eSales"(Rec);
                end;
            }

        }

    }

    /*
        trigger OnOpenPage()
        var

        begin
            //Rec.SetCurrentKey("No.", "Document Type");
            Rec.Ascending(false);
            Rec.FindFirst();
        end;
    */

    var




}


