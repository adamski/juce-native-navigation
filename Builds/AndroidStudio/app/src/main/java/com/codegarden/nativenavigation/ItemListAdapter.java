package com.codegarden.nativenavigation;

import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.CardView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import java.util.List;

/**
 * Created by adamelemental on 09/11/15.
 */
public class ItemListAdapter extends RecyclerView.Adapter<ItemListAdapter.ItemViewHolder>{

    List<Item> items;
    private static ClickListener clickListener;

    ItemListAdapter(List<Item> items){
        this.items = items;
    }

    public void setOnItemClickListener(ClickListener clickListener) {
        this.clickListener = clickListener;
    }

    @Override
    public ItemViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.drawer_item, parent, false);
        ItemViewHolder personViewHolder = new ItemViewHolder(view);
        return personViewHolder;
    }

    @Override
    public void onBindViewHolder(ItemViewHolder holder, int position) {
        holder.itemTitle.setText(items.get(position).title);
    }

    @Override
    public int getItemCount() {
        if (items != null) {
            return items.size();
        }
        else {
            return 0;
        }
    }

    @Override
    public void onAttachedToRecyclerView(RecyclerView recyclerView) {
        super.onAttachedToRecyclerView(recyclerView);
    }

    public Item getItem(int position) {
        return items.get(position);
    }

    public interface ClickListener {
        void onItemClick(int position, View view);
    }

    public static class ItemViewHolder extends RecyclerView.ViewHolder implements View
            .OnClickListener {
        //CardView cv;
        TextView itemTitle;

        ItemViewHolder(View itemView) {
            super(itemView);
            //cv = (CardView)itemView.findViewById(R.id.cv);
            itemTitle = (TextView)itemView.findViewById(android.R.id.text1);
            itemView.setOnClickListener(this);
        }

        @Override
        public void onClick(View view) {
            //clickListener.onItemClick(getPosition(), view);
            Log.d("ItemListAdapter", "row " + getAdapterPosition() + " clicked");
        }
    }

}
