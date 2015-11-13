package com.codegarden.nativenavigation;

import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import java.util.List;

/**
 * Created by adamelemental on 09/11/15.
 */
public class MessageListAdapter extends RecyclerView.Adapter<MessageListAdapter.MessageViewHolder>{

    static List<Message> messages;
    private static ClickListener clickListener;

    MessageListAdapter(List<Message> messages){
        this.messages = messages;
    }

    public void setOnItemClickListener(ClickListener clickListener) {
        this.clickListener = clickListener;
    }

    @Override
    public MessageViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.drawer_item, parent, false);
        MessageViewHolder messageViewHolder = new MessageViewHolder(view);
        return messageViewHolder;
    }

    @Override
    public void onBindViewHolder(MessageViewHolder holder, int position) {
        holder.itemTitle.setText(messages.get(position).title);
    }

    @Override
    public int getItemCount() {
        if (messages != null) {
            return messages.size();
        }
        else {
            return 0;
        }
    }

    @Override
    public void onAttachedToRecyclerView(RecyclerView recyclerView) {
        super.onAttachedToRecyclerView(recyclerView);
    }

    public Message getItem(int position) {
        return messages.get(position);
    }

    public interface ClickListener {
        void onItemClick(int position, View view);
    }

    public static class MessageViewHolder extends RecyclerView.ViewHolder implements View
            .OnClickListener {
        //CardView cv;
        TextView itemTitle;

        MessageViewHolder(View itemView) {
            super(itemView);
            //cv = (CardView)itemView.findViewById(R.id.cv);
            itemTitle = (TextView)itemView.findViewById(android.R.id.text1);
            itemView.setOnClickListener(this);
        }

        @Override
        public void onClick(View view) {
            //clickListener.onItemClick(getPosition(), view);
            Log.d("MessageListAdapter", "row " + getAdapterPosition() + " clicked");
            JuceActivity.setMessage(messages.get(getAdapterPosition()).title, messages.get(getAdapterPosition()).message);
        }
    }

}
