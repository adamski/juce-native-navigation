package com.codegarden.nativenavigation;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.util.AttributeSet;
import android.view.View;
import android.widget.AdapterView;

import java.util.List;

/**
 * Created by adamelemental on 09/11/15.
 */
public class ItemListView extends RecyclerView {
    private List<Item> items;

    public ItemListView(Context context, AttributeSet attrs, List<Item> items) {
        super(context, attrs);
        this.items = items;
    }

    @Override protected void onFinishInflate() {
        super.onFinishInflate();
        final ItemListAdapter adapter = new ItemListAdapter(items);
        setAdapter(adapter);
//        adapter.setOnItemClickListener(new OnItemClickListener() {
//            @Override public void onItemClick(AdapterView<?> parent, View view,
//                                              int position, long id) {
//                String item = adapter.getItem(position);
//                ListActivity activity = (ListActivity) getContext();
//                Container container = activity.getContainer();
//                container.showItem(item);
//            }
//        });
    }
}
