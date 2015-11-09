package com.codegarden.nativenavigation;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.ListView;

/**
 * Created by adamelemental on 09/11/15.
 */
public class ItemListView extends ListView {
    public ItemListView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    @Override protected void onFinishInflate() {
        super.onFinishInflate();
        final MyListAdapter adapter = new MyListAdapter();
        setAdapter(adapter);
        setOnItemClickListener(new OnItemClickListener() {
            @Override public void onItemClick(AdapterView<?> parent, View view,
                                              int position, long id) {
                String item = adapter.getItem(position);
                MainActivity activity = (MainActivity) getContext();
                Container container = activity.getContainer();
                container.showItem(item);
            }
        });
    }
}
