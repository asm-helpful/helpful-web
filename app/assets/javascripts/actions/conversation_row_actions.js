var ConversationRowActions = {
  toggleOpen: function(conversation) {
    if(conversation.open) {
      Dispatcher.dispatch({
        actionType: 'CONVERSATION_ROW_CLOSE',
        id: conversation.id
      })
    } else {
      Dispatcher.dispatch({
        actionType: 'CONVERSATION_ROW_OPEN',
        id: conversation.id
      })
    }
  }
}
