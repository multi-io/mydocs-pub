package com.android.demo.notepad1;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.widget.TextView;

public class EditActivity extends Activity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.notepad_editor);
		TextView txtTitle = (TextView) findViewById(R.id.txtTitle);
		TextView txtBody = (TextView) findViewById(R.id.txtBody);
		Intent i = getIntent();
		if (null != i) {
			txtTitle.setText(i.getStringExtra(NotesDbAdapter.KEY_TITLE));
			txtBody.setText(i.getStringExtra(NotesDbAdapter.KEY_BODY));
		}
	}

}
