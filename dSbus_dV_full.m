function [dSbus_dVm, dSbus_dVa] = dSbus_dV_full(Ybus, V, VLL, Sdelta, Iwye, Idelta)

    N = length(V);
    Ibus = Ybus * V;
    Vnorm = V./abs(V);

    if issparse(Ybus)           %% sparse version (if Ybus is sparse)
        diagV       = sparse(1:N, 1:N, V, N, N);
        diagIbus    = sparse(1:N, 1:N, Ibus, N, N);
        diagVnorm   = sparse(1:N, 1:N, Vnorm, N, N);
        diagIwye    = sparse(1:N, 1:N, Iwye, N, N);
    else                        %% dense version
        diagV       = diag(V);
        diagIbus    = diag(Ibus);
        diagVnorm   = diag(Vnorm);
        diagIwye    = diag(Iwye);
    end

    dSbus_dVm = diagV * conj(Ybus * diagVnorm) + conj(diagIbus) * diagVnorm - diagIwye;
    dSbus_dVa = 1j * diagV * conj(diagIbus - Ybus * diagV);

    for n = 1:(N/3)
        Sab = Sdelta(3*n-2); Sbc = Sdelta(3*n-1); Sca = Sdelta(3*n);
        Iab = Idelta(3*n-2); Ibc = Idelta(3*n-1); Ica = Idelta(3*n);
        
        %% Constant Power
        if (abs(Sab)>0 || abs(Sbc)>0 || abs(Sca)>0)
            Va     = V(3*n-2);      Vb     = V(3*n-1);      Vc     = V(3*n);
            VnormA = Vnorm(3*n-2);  VnormB = Vnorm(3*n-1);  VnormC = Vnorm(3*n);
            Vab    = VLL(3*n-2);    Vbc    = VLL(3*n-1);    Vca    = VLL(3*n); 

            %% Magnitude
            dSa_dVam_ctPow = + VnormA*(Sab*(Vb/(Vab^2)) + Sca*(Vc/(Vca^2)));
            dSa_dVbm_ctPow = - VnormB*Sab*Va/(Vab^2);
            dSa_dVcm_ctPow = - VnormC*Sca*Va/(Vca^2);

            dSb_dVam_ctPow = - VnormA*Sab*Vb/(Vab^2);
            dSb_dVbm_ctPow = + VnormB*(Sbc*(Vc/(Vbc^2)) + Sab*(Va/(Vab^2)));
            dSb_dVcm_ctPow = - VnormC*Sbc*Vb/(Vbc^2);

            dSc_dVam_ctPow = - VnormA*Sca*Vc/(Vca^2);
            dSc_dVbm_ctPow = - VnormB*Sbc*Vc/(Vbc^2);
            dSc_dVcm_ctPow = + VnormC*(Sca*(Va/(Vca^2)) + Sbc*(Vb/(Vbc^2)));
            
            dSbus_dVm(3*n-2,3*n-2) = dSbus_dVm(3*n-2,3*n-2) + dSa_dVam_ctPow;
            dSbus_dVm(3*n-2,3*n-1) = dSbus_dVm(3*n-2,3*n-1) + dSa_dVbm_ctPow;
            dSbus_dVm(3*n-2,3*n  ) = dSbus_dVm(3*n-2,3*n  ) + dSa_dVcm_ctPow;
            dSbus_dVm(3*n-1,3*n-2) = dSbus_dVm(3*n-1,3*n-2) + dSb_dVam_ctPow;
            dSbus_dVm(3*n-1,3*n-1) = dSbus_dVm(3*n-1,3*n-1) + dSb_dVbm_ctPow;
            dSbus_dVm(3*n-1,3*n  ) = dSbus_dVm(3*n-1,3*n  ) + dSb_dVcm_ctPow;
            dSbus_dVm(3*n  ,3*n-2) = dSbus_dVm(3*n  ,3*n-2) + dSc_dVam_ctPow;
            dSbus_dVm(3*n  ,3*n-1) = dSbus_dVm(3*n  ,3*n-1) + dSc_dVbm_ctPow;
            dSbus_dVm(3*n  ,3*n  ) = dSbus_dVm(3*n  ,3*n  ) + dSc_dVcm_ctPow;
            
            % Angle
            dSa_dVaa_ctPow = + 1i*Va*(Sab*(Vb/(Vab^2)) + Sca*(Vc/(Vca^2)));
            dSa_dVba_ctPow = - 1i*Vb*Sab*Va/(Vab^2);
            dSa_dVca_ctPow = - 1i*Vc*Sca*Va/(Vca^2);

            dSb_dVaa_ctPow = - 1i*Va*Sab*Vb/(Vab^2);
            dSb_dVba_ctPow = + 1i*Vb*(Sbc*(Vc/(Vbc^2)) + Sab*(Va/(Vab^2)));
            dSb_dVca_ctPow = - 1i*Vc*Sbc*Vb/(Vbc^2);

            dSc_dVaa_ctPow = - 1i*Va*Sca*Vc/(Vca^2);
            dSc_dVba_ctPow = - 1i*Vb*Sbc*Vc/(Vbc^2);
            dSc_dVca_ctPow = + 1i*Vc*(Sca*(Va/(Vca^2)) + Sbc*(Vb/(Vbc^2)));
            
            dSbus_dVa(3*n-2,3*n-2) = dSbus_dVa(3*n-2,3*n-2) + dSa_dVaa_ctPow;
            dSbus_dVa(3*n-2,3*n-1) = dSbus_dVa(3*n-2,3*n-1) + dSa_dVba_ctPow;
            dSbus_dVa(3*n-2,3*n  ) = dSbus_dVa(3*n-2,3*n  ) + dSa_dVca_ctPow;
            dSbus_dVa(3*n-1,3*n-2) = dSbus_dVa(3*n-1,3*n-2) + dSb_dVaa_ctPow;
            dSbus_dVa(3*n-1,3*n-1) = dSbus_dVa(3*n-1,3*n-1) + dSb_dVba_ctPow;
            dSbus_dVa(3*n-1,3*n  ) = dSbus_dVa(3*n-1,3*n  ) + dSb_dVca_ctPow;
            dSbus_dVa(3*n  ,3*n-2) = dSbus_dVa(3*n  ,3*n-2) + dSc_dVaa_ctPow;
            dSbus_dVa(3*n  ,3*n-1) = dSbus_dVa(3*n  ,3*n-1) + dSc_dVba_ctPow;
            dSbus_dVa(3*n  ,3*n  ) = dSbus_dVa(3*n  ,3*n  ) + dSc_dVca_ctPow;
        end
        
        %% Constant Current
        if (abs(Iab)>0 || abs(Ibc)>0 || abs(Ica)>0)
            Va     = V(3*n-2);      Vb     = V(3*n-1);      Vc     = V(3*n);
            VnormA = Vnorm(3*n-2);  VnormB = Vnorm(3*n-1);  VnormC = Vnorm(3*n);
            Vab    = VLL(3*n-2);    Vbc    = VLL(3*n-1);    Vca    = VLL(3*n);
            
            %% Magnitude
            dSa_dVam_ctCur = - (Iab/(sqrt(3)*Vab))*(- abs(Vab)*Vb*VnormA/Vab + Va*(abs(Va)-abs(Vb)*cos(angle(Va)-angle(Vb)))/abs(Vab)) ...
                             + (Ica/(sqrt(3)*Vca))*(+ abs(Vca)*Vc*VnormA/Vca + Va*(abs(Va)-abs(Vc)*cos(angle(Va)-angle(Vc)))/abs(Vca));
            dSa_dVbm_ctCur = - (Va*Iab/(sqrt(3)*Vab))*(+ abs(Vab)*VnormB/Vab + (abs(Vb)-abs(Va)*cos(angle(Va)-angle(Vb)))/abs(Vab));
            dSa_dVcm_ctCur = + (Va*Ica/(sqrt(3)*Vca))*(- abs(Vca)*VnormC/Vca + (abs(Vc)-abs(Va)*cos(angle(Vc)-angle(Va)))/abs(Vca));

            dSb_dVam_ctCur = + (Vb*Iab/(sqrt(3)*Vab))*(- abs(Vab)*VnormA/Vab + (abs(Va)-abs(Vb)*cos(angle(Va)-angle(Vb)))/abs(Vab));
            dSb_dVbm_ctCur = - (Ibc/(sqrt(3)*Vbc))*(- abs(Vbc)*Vc*VnormB/Vbc + Vb*(abs(Vb)-abs(Vc)*cos(angle(Vb)-angle(Vc)))/abs(Vbc)) ...
                             + (Iab/(sqrt(3)*Vab))*(+ abs(Vab)*Va*VnormB/Vab + Vb*(abs(Vb)-abs(Va)*cos(angle(Vb)-angle(Va)))/abs(Vab));
            dSb_dVcm_ctCur = - (Vb*Ibc/(sqrt(3)*Vbc))*(+ abs(Vbc)*VnormC/Vbc + (abs(Vc)-abs(Vb)*cos(angle(Vc)-angle(Vb)))/abs(Vbc));

            dSc_dVam_ctCur = - (Vc*Ica/(sqrt(3)*Vca))*(+ abs(Vca)*VnormA/Vca + (abs(Va)-abs(Vc)*cos(angle(Va)-angle(Vc)))/abs(Vca));
            dSc_dVbm_ctCur = + (Vc*Ibc/(sqrt(3)*Vbc))*(- abs(Vbc)*VnormB/Vbc + (abs(Vb)-abs(Vc)*cos(angle(Vb)-angle(Vc)))/abs(Vbc));
            dSc_dVcm_ctCur = - (Ica/(sqrt(3)*Vca))*(- abs(Vca)*Va*VnormC/Vca + Vc*(abs(Vc)-abs(Va)*cos(angle(Vc)-angle(Va)))/abs(Vca)) ...
                             + (Ibc/(sqrt(3)*Vbc))*(+ abs(Vbc)*Vb*VnormC/Vbc + Vc*(abs(Vc)-abs(Vb)*cos(angle(Vc)-angle(Vb)))/abs(Vbc));

            dSbus_dVm(3*n-2,3*n-2) = dSbus_dVm(3*n-2,3*n-2) + dSa_dVam_ctCur;
            dSbus_dVm(3*n-2,3*n-1) = dSbus_dVm(3*n-2,3*n-1) + dSa_dVbm_ctCur;
            dSbus_dVm(3*n-2,3*n  ) = dSbus_dVm(3*n-2,3*n  ) + dSa_dVcm_ctCur;
            dSbus_dVm(3*n-1,3*n-2) = dSbus_dVm(3*n-1,3*n-2) + dSb_dVam_ctCur;
            dSbus_dVm(3*n-1,3*n-1) = dSbus_dVm(3*n-1,3*n-1) + dSb_dVbm_ctCur;
            dSbus_dVm(3*n-1,3*n  ) = dSbus_dVm(3*n-1,3*n  ) + dSb_dVcm_ctCur;
            dSbus_dVm(3*n  ,3*n-2) = dSbus_dVm(3*n  ,3*n-2) + dSc_dVam_ctCur;
            dSbus_dVm(3*n  ,3*n-1) = dSbus_dVm(3*n  ,3*n-1) + dSc_dVbm_ctCur;
            dSbus_dVm(3*n  ,3*n  ) = dSbus_dVm(3*n  ,3*n  ) + dSc_dVcm_ctCur;

            %% Angle
            dSa_dVaa_ctCur = - (Iab/(sqrt(3)*Vab))*(- abs(Vab)*Vb*1i*Va/Vab + Va*(abs(Va)*abs(Vb)*sin(angle(Va)-angle(Vb)))/abs(Vab)) ...
                             + (Ica/(sqrt(3)*Vca))*(+ abs(Vca)*Vc*1i*Va/Vca + Va*(abs(Va)*abs(Vc)*sin(angle(Va)-angle(Vc)))/abs(Vca));
            dSa_dVba_ctCur = - (Va*Iab/(sqrt(3)*Vab))*(+ abs(Vab)*1i*Vb/Vab + (abs(Vb)*abs(Va)*sin(angle(Vb)-angle(Va)))/abs(Vab));
            dSa_dVca_ctCur = + (Va*Ica/(sqrt(3)*Vca))*(- abs(Vca)*1i*Vc/Vca + (abs(Vc)*abs(Va)*sin(angle(Vc)-angle(Va)))/abs(Vca));

            dSb_dVaa_ctCur = + (Vb*Iab/(sqrt(3)*Vab))*(- abs(Vab)*1i*Va/Vab + (abs(Va)*abs(Vb)*sin(angle(Va)-angle(Vb)))/abs(Vab));
            dSb_dVba_ctCur = - (Ibc/(sqrt(3)*Vbc))*(- abs(Vbc)*Vc*1i*Vb/Vbc + Vb*(abs(Vb)*abs(Vc)*sin(angle(Vb)-angle(Vc)))/abs(Vbc)) ...
                             + (Iab/(sqrt(3)*Vab))*(+ abs(Vab)*Va*1i*Vb/Vab + Vb*(abs(Vb)*abs(Va)*sin(angle(Vb)-angle(Va)))/abs(Vab));
            dSb_dVca_ctCur = - (Vb*Ibc/(sqrt(3)*Vbc))*(+ abs(Vbc)*1i*Vc/Vbc + (abs(Vc)*abs(Vb)*sin(angle(Vc)-angle(Vb)))/abs(Vbc));

            dSc_dVaa_ctCur = - (Vc*Ica/(sqrt(3)*Vca))*(+ abs(Vca)*1i*Va/Vca + (abs(Va)*abs(Vc)*sin(angle(Va)-angle(Vc)))/abs(Vca));
            dSc_dVba_ctCur = + (Vc*Ibc/(sqrt(3)*Vbc))*(- abs(Vbc)*1i*Vb/Vbc + (abs(Vb)*abs(Vc)*sin(angle(Vb)-angle(Vc)))/abs(Vbc));
            dSc_dVca_ctCur = - (Ica/(sqrt(3)*Vca))*(- abs(Vca)*Va*1i*Vc/Vca + Vc*(abs(Vc)*abs(Va)*sin(angle(Vc)-angle(Va)))/abs(Vca)) ...
                             + (Ibc/(sqrt(3)*Vbc))*(+ abs(Vbc)*Vb*1i*Vc/Vbc + Vc*(abs(Vc)*abs(Vb)*sin(angle(Vc)-angle(Vb)))/abs(Vbc));
            
            dSbus_dVa(3*n-2,3*n-2) = dSbus_dVa(3*n-2,3*n-2) + dSa_dVaa_ctCur;
            dSbus_dVa(3*n-2,3*n-1) = dSbus_dVa(3*n-2,3*n-1) + dSa_dVba_ctCur;
            dSbus_dVa(3*n-2,3*n  ) = dSbus_dVa(3*n-2,3*n  ) + dSa_dVca_ctCur;
            dSbus_dVa(3*n-1,3*n-2) = dSbus_dVa(3*n-1,3*n-2) + dSb_dVaa_ctCur;
            dSbus_dVa(3*n-1,3*n-1) = dSbus_dVa(3*n-1,3*n-1) + dSb_dVba_ctCur;
            dSbus_dVa(3*n-1,3*n  ) = dSbus_dVa(3*n-1,3*n  ) + dSb_dVca_ctCur;
            dSbus_dVa(3*n  ,3*n-2) = dSbus_dVa(3*n  ,3*n-2) + dSc_dVaa_ctCur;
            dSbus_dVa(3*n  ,3*n-1) = dSbus_dVa(3*n  ,3*n-1) + dSc_dVba_ctCur;
            dSbus_dVa(3*n  ,3*n  ) = dSbus_dVa(3*n  ,3*n  ) + dSc_dVca_ctCur;
        end
    end
    
end % End of function