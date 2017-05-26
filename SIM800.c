#include "SIM800.h"

extern char rec_buff[rec_buff_size];
extern long int buff_counter;

extern int val[8];
extern char VAR_1[7];
extern char VAR_2[7];
extern char VAR_3[7];
extern char VAR_4[7];
extern char VAR_5[7];
extern char VAR_6[7];
extern char VAR_7[7];
extern char VAR_8[7];
extern char _SERVER_[20];
extern char _APN_[20];
extern char _HOST_[20];
extern char _PAGEADDRESS_[50];
extern char _SUCCESSSIGN_[20];

//Functions:
//This Function is for emptying any array || buff_2_empty: The Array || cells_2_empty: the number of cells should be cleaned.
void emp_str(char *buff_2_empty,int cells_2_empty)
{
    int ii;
    for (ii=0;ii<cells_2_empty;ii++)
    {
        buff_2_empty[ii]='\0';
    }
}

//This Function is for searching the recieved buffer from GSM Module for a specific string. if the string found, it will return 1. else 0.
//Headers Needed: string.h
//Global vars needed: rec_buff
int search(char *str_to_search)
{
    if(strstr(rec_buff,str_to_search))
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

//This function waites until it saw a specefic string in recieved buffer.
//Input paramiters: str_2_s: string to see, time_out: time out in sec
//output: if saw before time out:1 else 0
//headers needed: delay.h
int wait_until(char* str_2_s,int time_out)
{
    int t_out=1;
    while(!search(str_2_s) && t_out<=10*time_out)
    {
        t_out++;
        delay_ms(100);
    }
    if(t_out<10*time_out)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

//This function clears All cell in rec_buff (data from module)
//Global Vars Needed: buff_counter, rec_buff
void clear_rec_buff(void)
{
    emp_str(rec_buff,rec_buff_size-1);
    buff_counter=0;
}

//AT Command send Function.
void at_command(char* at_cmnd)
{
   printf("%s%c",at_cmnd,0x0d);
}

//õSend Ctrl+Z to Modem:
//Headers Needed: delay.h
ctrl_z(void)
{
    delay_ms(100);
    printf("%c",0x1a);
    delay_ms(50);
}

//This Function initialize the sim800 Module || pin_code: the simcard pin
//if pin code is deactivated, let it be free like this: sim800_init("")
//Headers Needed: delay.h
void sim800_init(char* pin_code)
{
    char at_buff[12];

    at_command("ATZ");  //Reset Module
    delay_ms(100);
    at_command("AT&F"); //Factory reset Module
    delay_ms(200);

    at_command("AT+CMEE=1"); //Deactive echo
    delay_ms(50);

    //at_command("ATE0"); //Deactive echo
    delay_ms(50);

    clear_rec_buff();
    //check pin code:
    at_command("AT+CPIN?");
    delay_ms(50);

    if(!search("READY"))
    {
        sprintf(at_buff,"AT+CPIN=\"%s\"",pin_code);
        at_command(at_buff);
        delay_ms(100);
    }
}

//This Function initialize sending sms in module.
//headers needed: delay.h
void sms_init(void)
{
    at_command("AT+CMGF=1");
    delay_ms(50);

    at_command("AT+CSMP=17,196,0,0");
    delay_ms(50);

    at_command("AT+CSCS=\"GSM\"");
    delay_ms(50);
}

//This Function will check if the module is respond.
int sim_800_ping(void)
{
    clear_rec_buff();
    at_command("AT"); 
    if(wait_until("OK",1))
    {
       delay_ms(50);
       return 1; 
    }           
    else
    {
        delay_ms(50);
        return 0;
    } 
}
//This Function checks the Module registration in network
//Headers needed: delay.h
int check_reg(void)
{
    clear_rec_buff();
    at_command("AT+CREG?");
    delay_ms(100);
    if(search("0,1"))
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

//This Function sends sms
//headers needed: delay.h
int send_sms(char* sms_text, char* phone_number)
{
    char at_buff[25];
    int time_out=0;
    int stat=0;

    sms_init();
    clear_rec_buff();
    sprintf(at_buff,"AT+CMGS=\"+%s\"",phone_number);
    at_command(at_buff);
    delay_ms(100);
    while(!search(">") && time_out<50)
    {
        time_out++;
        delay_ms(100);
    }
    if(time_out<50)  //means that it saw >
    {
        printf("%s",sms_text);
        delay_ms(1000);
        ctrl_z();

        time_out=0;
        clear_rec_buff();
        while(!search("OK") && time_out<10)
        {
            time_out++;
            delay_ms(1000);
        }
        if(time_out<10)
        {
            stat=1;
        }
    }
    return stat;
}

//This function initializes socket connection in module
//Example: socket_init("Irancell-GPRS")
//headers needed: delay.h
int socket_init(char* APN_name)
{
    char at_buff_[35];
    int step=1;
    clear_rec_buff();

//lcd_clear();

    if(step==1)
    {
//lcd_puts("1 ");
        at_command("AT");
        if(wait_until("OK",1))
        {
            step++;
            delay_ms(500);
        }
    }
    clear_rec_buff();

    if(step==2)
    {
//lcd_puts("2 ");
        at_command("AT+CGATT=1");
        wait_until("OK",10);

        sprintf(at_buff_,"AT+CGDCONT=1,\"IP\",\"%s\"",APN_name);
        at_command(at_buff_);
        delay_ms(100);

        if(!search("ERROR"))
        {
            step++;
        }
    }
    clear_rec_buff();

    if(step==3)
    {
//lcd_puts("3 ");
        sprintf(at_buff_,"AT+CSTT=\"%s\",\"\",\"\"",APN_name);
        at_command(at_buff_);
        if(wait_until("OK",10))
        {
            step++;
        }
    }
    clear_rec_buff();

    if(step==4)
    {
//lcd_puts("4 ");
        at_command("AT+CIICR");
        if(wait_until("OK",15))
        {
            step++;
        }
    }
    clear_rec_buff();

    if(step==5)
    {
//lcd_puts("5 ");
        at_command("AT+CIFSR");
        delay_ms(500);
        step++;
    }
    if(step<6)
    {
//lcd_puts("NOT");
        return 0;
    }
    else
    {
//lcd_puts("6 ");
        return 1;
    }
}

//This Function will open socket to inputed ip (or domain) and port 80
int open_socket(char *server)
{
    char at_buff[50];
    clear_rec_buff();

    at_command("AT+CIPHEAD=1");
    wait_until("OK",3);
    clear_rec_buff();

    sprintf(at_buff,"AT+CIPSTART=\"TCP\",\"%s\",\"80\"",server);
    at_command(at_buff);
    wait_until("OK",3);

    wait_until("CONNECT",20);

    if(search("ALREADY"))
    {
//lcd_clear();
//lcd_puts("ALREADY");
        return 2;
    }
    else if(search("CONNECT OK"))
    {
//lcd_clear();
//lcd_puts("c OK");
        return 1;
    }
    else if(search("FAIL"))
    {
//lcd_clear();
//lcd_puts("fail");
        return 0;
    }
    else
    {
        return 0;
    }
}

//Function fot ready to send DATA in socket
//headers: delay.h, string.h
//success_sign: means the string that is sign for beggining of the return value of the server, ex: success
int socket_send_data(char* socket_data, char* success_sign)
{
    int stat=0;
    clear_rec_buff();
    delay_ms(100);
    at_command("AT+CIPSEND");

    if(wait_until(">",20))
    {
//lcd_clear();
//lcd_puts(">");
        clear_rec_buff();
        printf("%s",socket_data);
        delay_ms(500);
        ctrl_z();
        delay_ms(50);
        ctrl_z();
        if(wait_until("SEND OK",20))
        {
//lcd_puts("Send OK");
           stat=1;
           if(wait_until(success_sign,30))
           {
//lcd_puts("succs");
            delay_ms(1000);
//lcd_clear();
//lcd_puts(ret);
           }
        }

    }

    return stat;
}


//this function will init the program data variables
void prog_init(void)
{
    //Data Var naming:
   sprintf(VAR_1,        "l");
   sprintf(VAR_2,        "t");
   sprintf(VAR_3,        "m");
   sprintf(VAR_4,        "b");
   sprintf(VAR_5,        "c");
   sprintf(VAR_6,        "s");
   sprintf(VAR_7,        "a");
   sprintf(VAR_8,        "n");

    //Server Paramiters:
   sprintf(_SERVER_,     "104.28.25.5");
   sprintf(_APN_,        "Irancell-GPRS");
   sprintf(_HOST_,       "gologram.com");
   sprintf(_PAGEADDRESS_,"/api/v1/probes/process");
   sprintf(_SUCCESSSIGN_,"success\":true");

}

//this function will close socket
void close_socket(void)
{
    at_command("AT+CIPClOSE");
    wait_until("OK",3);
}

//this function disconnects GPRS connection
void gprs_dis(void)
{
    at_command("AT+CIPSHUT");
    wait_until("OK",5);
}
//this function will upload variables to server by http post method.
int post_data(int vars_value[8])
{
    int _time_out=0;   
    int _time_out1=0;
    char post_buff[200];
    char data_value[100];
    //strlen
    sprintf(data_value,"%s=%d&%s=%d&%s=%d&%s=%d&%s=%d&%s=%d&%s=%d&%s=%d",VAR_1,vars_value[0],VAR_2,vars_value[1],VAR_3,vars_value[2],VAR_4,vars_value[3],VAR_5,vars_value[4],VAR_6,vars_value[5],VAR_7,vars_value[6],VAR_8,vars_value[7]);
    sprintf(post_buff,"POST %s HTTP/1.0\r\nHost: %s\r\nUser-Agent: HTTPTool/1.0\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: %d\r\n\r\n%s\r\n\r\n",_PAGEADDRESS_,_HOST_,strlen(data_value),data_value);

    _time_out1=0;  
    
    socketstart:         
    while(socket_init(_APN_)!=1 && _time_out<=5)
    {
        //wait until connect to socket
        _time_out++;
    }

    open_socket(_SERVER_);
    if(socket_send_data(post_buff,_SUCCESSSIGN_))
    {
        close_socket();
        delay_ms(500);
        gprs_dis();
        return 1;
    }
    else if(_time_out1<=5)
    {
//lcd_puts("retry");
        _time_out1++;
        close_socket(); 
        gprs_dis();
        delay_ms(1000);
        goto socketstart;
    }
    else
    {
        close_socket();
        delay_ms(500);
        gprs_dis();
        return 0;
    }
}


//This function turns on module
int sim800_on(void)
{
    clear_rec_buff();
    at_command("AT");    
    delay_ms(100);
    if(!search("OK"))
    {
        PORTC.3=1;
        delay_ms(3000);
        PORTC.3=0;
    }
    clear_rec_buff();
    at_command("AT"); 
    if(wait_until("OK",1))
    {
        return 1;
    }
    else
    {   
        PORTC.3=1;
        delay_ms(3000);
        PORTC.3=0;
        return 0;
    }
}

//This function turns OFF module
int sim800_off(void)
{
    PORTC.3=1;
    delay_ms(3000);
    PORTC.3=0;  
    
    clear_rec_buff();
    at_command("AT");
    if(wait_until("OK",1))
    {   
        PORTC.3=1;
        delay_ms(3000);
        PORTC.3=0;
        
        return 0;
    }
    else
    {
        return 1;
    }
}

//This Function will reset sim800
void sim800_reset(void)
{
    sim800_off();
    sim800_on();
}
//signal quality:
int signal_q(void)
{
    char sig_buff[3];
    int i_=0;
    int j_=0;

    emp_str(sig_buff,3);
    clear_rec_buff();
    at_command("AT+CSQ");
    wait_until("CSQ",1);
    while(rec_buff[i_]!=':' && i_<=20)
    {
        i_++;
    }
    i_++;
    while(rec_buff[i_]!=',' && j_<=2)
    {
        sig_buff[j_]=rec_buff[i_];
        i_++;
        j_++;
    }
    while(j_<=2)
    {
        sig_buff[j_]='\0';
        j_++;
    }
    return atoi(sig_buff);
}

// get server time
void get_server_time(int *s_year, int* s_mon, int* s_dat, int* s_hour, int* s_min, int* s_sec)
{
    volatile int ii=0;
    volatile int jj=0;

    char YEAR[5];
    char MONTH[3];
    char DATE[3];
    char HOUR[3];
    char MIN[3];
    char SEC[3];

    while(ii<=rec_buff_size)
    {
        if(rec_buff[ii]=='t' &&  rec_buff[ii+1]=='i' && rec_buff[ii+2]=='m' && rec_buff[ii+3]=='e' && rec_buff[ii+4]=='"')
        {
            ii=ii+7;
            while(jj<4)
            {
               YEAR[jj]=rec_buff[ii];
               jj++;
               ii++;
            }
            YEAR[4]='\0';
            ii++;
            jj=0;
            while(jj<2)
            {
               MONTH[jj]=rec_buff[ii];
               jj++;
               ii++;
            }
            MONTH[2]='\0';
            ii++;
            jj=0;
            while(jj<2)
            {
                DATE[jj]=rec_buff[ii];
                jj++;
                ii++;
            }
            DATE[2]='\0';
            ii++;
            jj=0;
            while(jj<2)
            {
                HOUR[jj]=rec_buff[ii];
                jj++;
                ii++;
            }
            HOUR[2]='\0';
            ii++;
            jj=0;
            while(jj<2)
            {
                MIN[jj]=rec_buff[ii];
                jj++;
                ii++;
            }
            MIN[2]='\0';
            ii++;
            jj=0;
            while(jj<2)
            {
                SEC[jj]=rec_buff[ii];
                ii++;
                jj++;
            }
            SEC[2]='\0';


            *s_year=atoi(YEAR);
            *s_mon= atoi(MONTH);
            *s_dat= atoi(DATE);
            *s_hour=atoi(HOUR);
            *s_min= atoi(MIN);
            *s_sec= atoi(SEC);

            break;
        }
        ii++;
    }
}