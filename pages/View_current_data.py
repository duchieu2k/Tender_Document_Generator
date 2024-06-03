import streamlit as st
import sys
import os
import logging
from utils import *
import time 
import yaml

## EXPLAIN: setting shell_output = False will create a default log Streamhandler, which by default send all   all Python log to stderr
## then we send all console stdout to TerminalOutput tab
## all stderr data (which include formatted log) to the LogData tab

LOGGER_INIT(log_level=logging.DEBUG,
                      print_log_init = False,
                      shell_output= False) 



######################## Logging TAB ##########################################
with st.sidebar:
    TerminalOutput, LoggingOutput= init_logging_popup_button()


with st_stdout("code",TerminalOutput, cache_data=True), st_stderr("code",LoggingOutput, cache_data=True):
    if "bid_info_input_dict" not in st.session_state:
        st.session_state["bid_info_input_dict"] = ''

    if "customer_info_input_dict" not in st.session_state:
        st.session_state["customer_info_input_dict"] = ''

    yaml_file_path = os.path.normpath(
                            os.path.join(
                                os.path.dirname(os.path.abspath(__file__)),
                                ".." , 
                                "data/project_data.yaml")
    )
    with open(yaml_file_path,'r',encoding='utf8') as data_file:
        data = yaml.safe_load(data_file,)

    st.data_editor(data['SVTECH_INFO'])
    st.data_editor(data['BID_INFO'])
    st.data_editor(data['BID_OWNER'])