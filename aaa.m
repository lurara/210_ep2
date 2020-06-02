
                if(j == 1) # ok
                  a02 = (double (aux(i, j+1)) - double(aux(i,j)))/h;
                else
                  a02 = (double (aux(i, j+1)) - double(aux(i, j-1)))/(2*h);
                endif
                
                if(j == n-1) # ok
                  a03 = (double(aux(i, j+1)) - double(aux(i, j)))/h;
                else
                  a03 = (double(aux(i, j+2)) - double(aux(i, j)))/(2*h);
                endif
                
                a10 = double (aux(i+1, j));
                a11 = double (aux(i+1, j+1));
                
                if(j == 1) # ok
                  a12 = (double (aux(i+1, j+1)) - double (aux(i+1,j)))/h;
                else
                  a12 = (double (aux(i+1, j+1)) - double(aux(i+1, j-1)))/(2*h);
                endif
                
                if(j == n-1) # ok
                  a13 = (double(aux(i+1, j+1)) - double(aux(i+1, j)))/h;
                else
                  a13 = (double(aux(i+1, j+2)) - double(aux(i+1, j)))/(2*h);
                endif
                
                if(i == 1)  # ok
                  a20 = (double (aux(i+1, j)) - double (aux(i, j)))/(h);
                else
                  a20 = ( double (aux(i+1, j)) - double (aux(i-1, j)))/(2*h);
                endif
                
                if(i == 1) # ok
                  a21 = (double (aux(i+1, j+1)) - double (aux(i, j+1)))/(h);
                else
                  a21 = (double (aux(i+1, j+1)) - double (aux(i-1, j+1)))/(2*h);
                endif
                
                if(i == 1) # ??
                  a22 = (a12 - a02)/h;                  
                else
                  a22 = (a12 - delij)/(2*h);
                endif
                
                if(i == 1) # ??
                  a23 = (a13 - a03)/h;
                else
                  a23 = (a13 - deliJ)/(2*h);
                endif
                
                if(i == n-1) # ok
                  a30 = (double (aux(i+1, j)) - double (aux(i, j)))/(h);
                else
                  a30 = (double (aux(i+2, j)) - double(aux(i, j)))/(2*h);
                endif
              
                if(i == n-1) # ok
                  a31 = (double (aux(i+1, j+1)) - double (aux(i, j+1)))/(h);
                else
                  a31 = (double (aux(i+2, j+1)) - double (aux(i, j+1)))/(2*h);
                endif
                
                if(i == n-1) # ??
                  a32 = (a12 - a02)/h;
                else
                  a32 = (delIj - a02)/(2*h);
                endif
                
                if(i == n-1) # ??
                  a33 = (a13 - a03)/h;
                else
                  a33 = (delIJ - a03)/(2*h);
                endif