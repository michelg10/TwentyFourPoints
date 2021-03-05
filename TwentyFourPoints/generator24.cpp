#include <vector>
#include <chrono>
#include <random>
#include "generator24.hpp"
using namespace std;

struct expression {
    int mode; //0 for the binary tree, 1 for the weird thing
    int opr1,opr2,opr3;
    int n1,n2,n3,n4;
};
string oprToString(int x) {
    if (x==0) {
        return "+";
    }
    if (x==1) {
        return "-";
    }
    if (x==2) {
        return "*";
    }
    if (x==3) {
        return "/";
    }
    if (x==4) {
        return "_";
    }
    if (x==5) {
        return "\\";
    }
    return "Invalid opr "+to_string(x);
}
struct expressionInfo {
    string expStr;
    int negs;
    int parens;
};

double eval(double a,double b,int opr) {
    double rturn=0;
    switch (opr) {
        case 0:
            rturn=a+b;
            break;
        case 1:
            rturn=a-b;
            break;
        case 2:
            rturn=a*b;
            break;
        case 3:
            rturn=a/b;
            break;
        case 4:
            rturn=b-a;
            break;
        case 5:
            rturn=b/a;
            break;
        default:
            break;
    }
    return rturn;
}

expressionInfo humanfyExpr(expression x) {
    int negs=0;
    int parens=0;
//    cout<<"Requested simplification of ";
    if (x.mode==0) {
//        cout<<"("<<x.n1<<oprToString(x.opr2)<<x.n2<<")"<<oprToString(x.opr1)<<"("<<x.n3<<oprToString(x.opr3)<<x.n4<<")"<<endl;
        string rturn;
        if ((x.opr1==2||x.opr1==3)&&(x.opr2==0||x.opr2==1)) {
            rturn="("+to_string(x.n1)+oprToString(x.opr2)+to_string(x.n2)+")"+oprToString(x.opr1);
            if (eval(x.n1,x.n2,x.opr2)<0) {
                negs++;
            }
            parens++;
            
        } else {
            rturn=to_string(x.n1)+oprToString(x.opr2)+to_string(x.n2)+oprToString(x.opr1);
        }
        if (x.opr1 == 0) {
            // everything's just off now
            rturn+=to_string(x.n3)+oprToString(x.opr3)+to_string(x.n4);
            return (expressionInfo){rturn,negs,parens};
        } else if (x.opr1==1) {
            if (x.opr3==2||x.opr3==3) {
                rturn+=to_string(x.n3)+oprToString(x.opr3)+to_string(x.n4);
                return (expressionInfo){rturn,negs,parens};
            } else if (x.opr3==0) {
                rturn+=to_string(x.n3)+"-"+to_string(x.n4);
                return (expressionInfo){rturn,negs,parens};
            } else if (x.opr3==1) {
                rturn+=to_string(x.n3)+"+"+to_string(x.n4);
                return (expressionInfo){rturn,negs,parens};
            }
        } else if (x.opr1==2) {
            if (x.opr3==0||x.opr3==1) {
                rturn+="("+to_string(x.n3)+oprToString(x.opr3)+to_string(x.n4)+")";
                parens++;
                if (eval(x.n3,x.n4,x.opr3)<0) {
                    negs++;
                }
                return (expressionInfo){rturn,negs,parens};
            } else {
                rturn+=to_string(x.n3)+oprToString(x.opr3)+to_string(x.n4);
                return (expressionInfo){rturn,negs,parens};
            }
        } else if (x.opr1==3) {
            if (x.opr3==0||x.opr3==1) {
                rturn+="("+to_string(x.n3)+oprToString(x.opr3)+to_string(x.n4)+")";
                parens++;
                if (eval(x.n3,x.n4,x.opr3)<0) {
                    negs++;
                }
                return (expressionInfo){rturn,negs,parens};
            } else if (x.opr3==2) {
                rturn+=to_string(x.n3)+"/"+to_string(x.n4);
                return (expressionInfo){rturn,negs,parens};
            } else if (x.opr3==3) {
                rturn+=to_string(x.n3)+"*"+to_string(x.n4);
                return (expressionInfo){rturn,negs,parens};
            }
        }
    } else {
//        cout<<"(("<<x.n3<<oprToString(x.opr3)<<x.n4<<")"<<oprToString(x.opr2)<<x.n2<<")"<<oprToString(x.opr1)<<x.n1<<endl;
        if (x.opr1==0||x.opr1==1||x.opr1==2||x.opr1==3) {
            string rturn="";
            if (x.opr2==0||x.opr2==1) {
                rturn=to_string(x.n3)+oprToString(x.opr3)+to_string(x.n4)+oprToString(x.opr2)+to_string(x.n2);
                if (x.opr1==2||x.opr1==3) {
                    if (eval(x.n2, eval(x.n3, x.n4, x.opr3), x.opr2)<0) {
                        negs++;
                    }
                }
            } else if (x.opr2==2||x.opr2==3) {
                if (x.opr3==0||x.opr3==1) {
                    // parentheses
                    rturn="("+to_string(x.n3)+oprToString(x.opr3)+to_string(x.n4)+")";
                    parens++;
                    if (eval(x.n3,x.n4,x.opr3)<0) {
                        negs++;
                    }
                } else {
                    rturn=to_string(x.n3)+oprToString(x.opr3)+to_string(x.n4);
                }
                rturn+=oprToString(x.opr2)+to_string(x.n2);
            } else if (x.opr2==4) {
                rturn=to_string(x.n2)+"-";
                if (x.opr3==0) {
                    rturn+=to_string(x.n3)+"-"+to_string(x.n4);
                } else if (x.opr3==1) {
                    rturn+=to_string(x.n3)+"+"+to_string(x.n4);
                } else {
                    rturn+=to_string(x.n3)+oprToString(x.opr3)+to_string(x.n4);
                }
                
                if (x.opr1==2||x.opr1==3) {
                    if (eval(x.n2, eval(x.n3, x.n4, x.opr3), x.opr2)<0) {
                        negs++;
                    }
                }
            } else {
                rturn=to_string(x.n2)+"/";
                if (x.opr3==0||x.opr3==1) {
                    parens++;
                    rturn+="("+to_string(x.n3)+oprToString(x.opr3)+to_string(x.n4)+")";
                    if (eval(x.n3,x.n4,x.opr3)<0) {
                        negs++;
                    }
                } else if (x.opr3==2) {
                    rturn+=to_string(x.n3)+"/"+to_string(x.n4);
                } else {
                    rturn+=to_string(x.n3)+"*"+to_string(x.n4);
                }
            }
            if ((x.opr1==2||x.opr1==3)&&(x.opr2==0||x.opr2==1||x.opr2==4)) {
                rturn="("+rturn+")";
                parens++;
            }
            rturn+=oprToString(x.opr1)+to_string(x.n1);
            return (expressionInfo){rturn,negs,parens};
        } else {
            string rturn=to_string(x.n1);
            if (x.opr2==0||x.opr2==1) {
                rturn+="/("+to_string(x.n3)+oprToString(x.opr3)+to_string(x.n4)+oprToString(x.opr2)+to_string(x.n2)+")";
                parens++;
                if (eval(x.n2, eval(x.n3, x.n4, x.opr3), x.opr2)<0) {
                    negs++;
                }
            } else if (x.opr2==2) {
                rturn+="/"+to_string(x.n2)+"/";
                if (x.opr3==0||x.opr3==1) {
                    rturn+="("+to_string(x.n3)+oprToString(x.opr3)+to_string(x.n4)+")";
                    parens++;
                    if (eval(x.n3, x.n4, x.opr3)) {
                        negs++;
                    }
                } else if (x.opr3==2) {
                    rturn+=to_string(x.n3)+"/"+to_string(x.n4);
                } else {
                    rturn+=to_string(x.n3)+"*"+to_string(x.n4);
                }
            } else if (x.opr2==3) {
                rturn+="*"+to_string(x.n2)+"/";
                if (x.opr3==0||x.opr3==1) {
                    rturn+="("+to_string(x.n3)+oprToString(x.opr3)+to_string(x.n4)+")";
                    parens++;
                    if (eval(x.n3, x.n4, x.opr3)) {
                        negs++;
                    }
                } else if (x.opr3==2) {
                    rturn+=to_string(x.n3)+"/"+to_string(x.n4);
                } else {
                    rturn+=to_string(x.n3)+"*"+to_string(x.n4);
                }
            } else if (x.opr2==4) {
                rturn+="/("+to_string(x.n2)+"-";
                if (x.opr3==0) {
                    rturn+=to_string(x.n3)+"-"+to_string(x.n4);
                } else if (x.opr3==1) {
                    rturn+=to_string(x.n3)+"+"+to_string(x.n4);
                } else {
                    rturn+=to_string(x.n3)+oprToString(x.opr3)+to_string(x.n4);
                }
                rturn+=")";
                parens++;
                if (eval(x.n2, eval(x.n3, x.n4, x.opr3), x.opr2)<0) {
                    negs++;
                }
            } else if (x.opr2==5) {
                rturn+="/"+to_string(x.n2)+"*";
                if (x.opr3==0||x.opr3==1) {
                    rturn+="("+to_string(x.n3)+oprToString(x.opr3)+to_string(x.n4)+")";
                    parens++;
                    if (eval(x.n3, x.n4, x.opr3)) {
                        negs++;
                    }
                } else {
                    rturn+=to_string(x.n3)+oprToString(x.opr3)+to_string(x.n4);
                }
            }
            return (expressionInfo){rturn,negs,parens};
        }
    }
    return (expressionInfo){"nop",negs,parens};;
}

double doubleEq(double a,double b) {
    return abs(a-b)<0.000001;
}

bool firstIsBetter(const expressionInfo &a, const expressionInfo &b) {
    if (a.negs!=b.negs) {
        return a.negs<b.negs;
    }
    if (a.parens!=b.parens) {
        return a.parens<b.parens;
    }
    if (a.expStr.length()!=b.expStr.length()) {
        return a.expStr.length()<b.expStr.length();
    }
    return false;
}

myString tomyString(string x) {
    char* stringData=new char[x.length()+1];
    for (int i=0;i<x.length();i++) stringData[i]=x[i];
    stringData[x.length()]='\0';
    int len=x.length();
    return (myString){stringData,len};
}

myString solve24(int a,int b,int c,int d) {
    int input[4] = {a,b,c,d};
    int perm[4]={0,1,2,3};
    expressionInfo rturn=(expressionInfo){"",100000,100000};
    bool rturnDoesFullyDivide=false;
    
    // prioritize ways using + and - only
    // then prioritize fully dividing
    // then prioritize non-negatives
    // then prioritize least parentheses
    
    do {
        int curInput[4];
        for (int i=0;i<4;i++) {
            curInput[i]=input[perm[i]];
        }
        
        // tree 1
        for (int o1=0;o1<4;o1++) {
            for (int o2=0;o2<4;o2++) {
                for (int o3=0;o3<4;o3++) {
                    double result=eval(eval(curInput[0], curInput[1], o2), eval(curInput[2], curInput[3], o3), o1);
                    if (doubleEq(result, 24.0)) {
                        expression expr=(expression){0,o1,o2,o3,curInput[0],curInput[1],curInput[2],curInput[3]};
                        expressionInfo ExpInfo=humanfyExpr(expr);
                        string s=ExpInfo.expStr;
                        
                        if ((o1==0||o1==1)&&(o2==0||o2==1)&&(o3==0||o3==1)) {
                            return tomyString(s);
                        }
                        bool fullyDivide=true;
                        if (o2==3) {
                            if (curInput[0]%curInput[1] != 0) fullyDivide=false;
                        }
                        if (o3==3) {
                            if (curInput[2]%curInput[3] != 0) fullyDivide=false;
                        }
                        
                        int resAtStage=eval(curInput[2], curInput[3], o3);
                        if (fullyDivide&&o1==3&&resAtStage!=0) { //if it still fully divides then the two sides must be integers. now check for the last full divide
                            if ((int)eval(curInput[0], curInput[1], o2)%resAtStage != 0) fullyDivide=false;
                        }
                        
                        if (fullyDivide) {
                            if (!rturnDoesFullyDivide) {
                                rturn=ExpInfo;
                                rturnDoesFullyDivide=true;
                            } else {
                                if (firstIsBetter(ExpInfo, rturn)) {
                                    rturn=ExpInfo;
                                }
                            }
                        } else {
                            if (!rturnDoesFullyDivide) {
                                if (firstIsBetter(ExpInfo, rturn)) {
                                    rturn=ExpInfo;
                                }
                            }
                        }
                    }
                }
            }
        }
        
        // tree 2
        for (int o1=0;o1<6;o1++) {
            if (o1==4) {
                continue; //this should only cause problems when using numbers greater than 24
            }
            for (int o2=0;o2<6;o2++) {
                for (int o3=0;o3<4;o3++) {
                    double result=eval(eval(eval(curInput[2], curInput[3], o3), curInput[1], o2), curInput[0], o1);
                    if (doubleEq(result, 24.0)) {
                        expression expr=(expression){1,o1,o2,o3,curInput[0],curInput[1],curInput[2],curInput[3]};
                        expressionInfo ExpInfo=humanfyExpr(expr);
                        string s=ExpInfo.expStr;
                        if ((o1==0||o1==1)&&(o2==0||o2==1)&&(o3==0||o3==1)) {
                            return tomyString(s);
                        }
                        
                        bool fullyDivide=true;
                        if (o3==3) {
                            if (curInput[2]%curInput[3] != 0) fullyDivide=false;
                        }
                        
                        int resAtStage=eval(curInput[2], curInput[3], o3);
                        if (fullyDivide&&o2==3) {
                            if (resAtStage%curInput[1] != 0) fullyDivide=false;
                        }
                        
                        if (fullyDivide&&o2==5&&resAtStage!=0) {
                            if (curInput[1]%resAtStage != 0) fullyDivide=false;
                        }
                        
                        resAtStage=eval(resAtStage,curInput[0],o1);
                        
                        if (fullyDivide&&o1==3) {
                            if (resAtStage%curInput[0] != 0) fullyDivide=false;
                        }
                        
                        if (fullyDivide&&o1==5&&resAtStage!=0) {
                            if (curInput[0]%resAtStage != 0) fullyDivide=false;
                        }
                        
                        if (fullyDivide) {
                            if (!rturnDoesFullyDivide) {
                                rturn=ExpInfo;
                                rturnDoesFullyDivide=true;
                            } else {
                                if (firstIsBetter(ExpInfo, rturn)) {
                                    rturn=ExpInfo;
                                }
                            }
                        } else {
                            if (!rturnDoesFullyDivide) {
                                if (firstIsBetter(ExpInfo, rturn)) {
                                    rturn=ExpInfo;
                                }
                            }
                        }
                    }
                }
            }
        }
    } while (next_permutation(perm, perm+4));
    if (rturn.expStr!="") {
        return tomyString(rturn.expStr);
    }
    char* nosol=strdup("nosol");
    return (myString){nosol,5};
}
problem24 generateProblem(int upperBound) {
    auto seed = chrono::high_resolution_clock::now().time_since_epoch().count();
    auto dice_rand = bind(uniform_int_distribution<int>(1,upperBound),mt19937(seed));
    while (true) {
        int nxt1=dice_rand();
        int nxt2=dice_rand();
        int nxt3=dice_rand();
        int nxt4=dice_rand();
        myString res=solve24(nxt1, nxt2, nxt3, nxt4);
        if (strncmp(res.data, "nosol", 5)!=0) {
            return (problem24){nxt1,nxt2,nxt3,nxt4,res};
        }
    }
}
