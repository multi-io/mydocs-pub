/*
 * Copyright (C) 2008 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.android.demo.notepad1;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Color;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.ListView;
import android.widget.SimpleCursorAdapter;
import android.widget.TextView;

public class ListActivity extends Activity {
    //private int mNoteNumber = 1;
    
	private ListView list;
    private NotesDbAdapter db;
    private Cursor listCursor;
    
    private final static int MID_CREATE_TESTDATA = Menu.FIRST;
    private final static int MID_DELETE_ALL_NOTES = Menu.FIRST + 1;

    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.notepad_list);
        list = (ListView) findViewById(android.R.id.list);
        //list.setAdapter(new SquareNumbersAdapter(20));
        list.setOnItemClickListener(new AdapterView.OnItemClickListener() {
        	@Override
        	public void onItemClick(AdapterView<?> parent, View view,
        			int position, long id) {
        		Log.d(this.getClass().getName(), "item clicked " + position + ", " + id);
        		startActivity(new Intent(ListActivity.this, EditActivity.class));
        	}
		});
        db = new NotesDbAdapter(this);
        db.open();
        refresh();
    }
    
    private void refresh() {
    	if (null != listCursor) {
    		stopManagingCursor(listCursor);
    	}
    	listCursor = db.fetchAllNotes();
    	startManagingCursor(listCursor);
    	list.setAdapter(new SimpleCursorAdapter(this, android.R.layout.simple_list_item_1, listCursor, new String[]{NotesDbAdapter.KEY_TITLE}, new int[]{android.R.id.text1}));
    }
    
    private class SquareNumbersAdapter extends BaseAdapter {
    	final int count;
    	public SquareNumbersAdapter(int count) {
    		this.count = count;
		}
    	@Override
    	public int getCount() {
    		return count;
    	}
    	@Override
    	public Object getItem(int position) {
    		return position*position;
    	}
    	@Override
    	public View getView(int position, View convertView, ViewGroup parent) {
    		View view;
    		if (null != convertView) {
    			view = convertView;
    		} else {
    			//text = new TextView(Notepadv1.this);
    			LayoutInflater inflater = (LayoutInflater)getSystemService(Context.LAYOUT_INFLATER_SERVICE);
                //text = (TextView) inflater.inflate(R.layout.quadnums_field, parent, false);
                view = inflater.inflate(android.R.layout.simple_list_item_1, parent, false);
    		}
    		TextView text;
    		if (view instanceof TextView) {
    			text = (TextView) view;
    		} else {
    			text = (TextView) view.findViewById(0);   //this is what ArrayAdapter does by default (ArrayAdapter#mFieldId==0)
    		}
    		text.setText(getItem(position).toString());
    		//text.setBackgroundColor(Color.HSVToColor(0xff, new float[]{120, (float)position/(count-1), 1}));
    		//text.setBackgroundColor(((0xff*position/count)<<24) | (Color.GREEN & 0xffffff));
    		view.setBackgroundColor(((0xff*position/count)<<24) | (Color.GREEN & 0xffffff));
    		return text;
    	}
    	@Override
    	public long getItemId(int position) {
    		return position;
    	}
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        menu.add(Menu.NONE, MID_CREATE_TESTDATA, Menu.NONE, R.string.create_testdata);
        menu.add(Menu.NONE, MID_DELETE_ALL_NOTES, Menu.NONE, R.string.delete_all_notes);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (super.onOptionsItemSelected(item)) {
        	return true;
        }
        switch (item.getItemId()) {
        case MID_CREATE_TESTDATA:
        	Log.i(this.getClass().getName(), "create testdata");
        	db.createNote("hello", "The first note.");
        	db.createNote("Apfelmus", "Lecker!");
        	db.createNote("Blah", "The quick brown fox jumps over the lazy dog.");
        	refresh();
        	return true;
        case MID_DELETE_ALL_NOTES:
        	Log.i(this.getClass().getName(), "delete all notes");
        	db.deleteAllNotes();
        	refresh();
        	return true;
        }
        return false;
    }
}
