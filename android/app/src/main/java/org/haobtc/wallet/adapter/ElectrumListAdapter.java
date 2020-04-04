package org.haobtc.wallet.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.RecyclerView;

import com.chad.library.adapter.base.BaseQuickAdapter;
import com.chad.library.adapter.base.BaseViewHolder;

import org.haobtc.wallet.R;
import org.haobtc.wallet.bean.CNYBean;

import java.util.ArrayList;

public class ElectrumListAdapter extends RecyclerView.Adapter<ElectrumListAdapter.myViewHolder> {
    private Context context;
    private ArrayList<CNYBean> electrumList;

    public ElectrumListAdapter(Context context, ArrayList<CNYBean> electrumList,int exchange) {
        this.context = context;
        this.electrumList = electrumList;
        this.electrumList.get(exchange).setStatus(true);
    }

    public class myViewHolder extends BaseViewHolder {
        TextView tet_electrumName;

        public myViewHolder(View view) {
            super(view);
            tet_electrumName = view.findViewById(R.id.tet_electrumName);
        }
    }

    @NonNull
    @Override
    public myViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View inflate = LayoutInflater.from(context).inflate(R.layout.node_item, null);
        return new myViewHolder(inflate);
    }

    @Override
    public void onBindViewHolder(@NonNull myViewHolder holder, int position) {
        holder.tet_electrumName.setText(electrumList.get(position).getName());
        holder.tet_electrumName.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                for (int i = 0; i < electrumList.size(); i++) {
                    electrumList.get(i).setStatus(false);
                }
                electrumList.get(position).setStatus(true);
                onLisennorClick.ItemClick(position);
                notifyDataSetChanged();

            }
        });
        if (electrumList.get(position).isStatus()) {
            holder.tet_electrumName.setTextColor(context.getColor(R.color.button_bk_disableok));
//            holder.tet_types.setBackgroundColor(Color.parseColor("#ffffff"));
        } else {
            holder.tet_electrumName.setTextColor(context.getColor(R.color.text));
        }
    }

    @Override
    public int getItemCount() {
        if (electrumList != null) {
            return electrumList.size();
        } else return 0;

    }

    public interface onLisennorClick {
        void ItemClick(int pos);
    }

    private onLisennorClick onLisennorClick;

    public void setOnLisennorClick(onLisennorClick onLisennorClick) {
        this.onLisennorClick = onLisennorClick;
    }

}
