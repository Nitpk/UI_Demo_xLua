/*
 * 作者：阳贻凡
 */
using System;
using UnityEngine;
using UIFramework;
using UnityEngine.Events;

namespace Demo
{
    /// <summary>
    /// 角色列表
    /// </summary>
    [XLua.LuaCallCSharp]
    public class CharacterViewList : ViewList<CharacterInfo>
    {
        /// <summary>
        /// 重置数据时回调
        /// </summary>
        private UnityAction<int,int> onCellSetData;
        /// <summary>
        /// 初始化列表格
        /// </summary>
        private Func<GameObject, int> onInitViewCellBundle;
        protected override void ResetCellData(int cellID, CharacterInfo data, int dataIndex)
        {
            onCellSetData?.Invoke(cellID,data.id);
        }

        public void SetDataCallBack(UnityAction<int,int> callBack)
        {
            onCellSetData = callBack;
        }


        protected override void InitViewCellBundle(ViewCellBundle viewCellBundle,int indexInBundle)
        {
            if (onInitViewCellBundle == null) return;

            viewCellBundle.CellsID[indexInBundle] = onInitViewCellBundle(viewCellBundle.Cells[indexInBundle]);
        }

        public void SetInitViewCellBundle(Func<GameObject, int> onInitViewCellBundle)
        {
            this.onInitViewCellBundle = onInitViewCellBundle;
        }
    }
}