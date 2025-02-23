/*
 * 作者：阳贻凡
 */
using System.Collections;
using UnityEngine;

namespace UIFramework
{
    /// <summary>
    /// 格子组合
    /// </summary>
    public class ViewCellBundle: IPoolData 
    {
        /// <summary>
        /// 行号
        /// </summary>
        public int index;
        /// <summary>
        /// 位置
        /// </summary>
        public Vector2 position;
        /// <summary>
        /// 格子集合
        /// </summary>
        public GameObject[] Cells { get; private set; }
        /// <summary>
        /// 格子id
        /// </summary>
        public int[] CellsID { get; private set; }
        /// <summary>
        /// 格子容量
        /// </summary>
        public int CellCapacity => Cells.Length;
        /// <summary>
        /// 是否初始化
        /// </summary>
        public bool IsInit { get; private set; }
        public ViewCellBundle() { IsInit = false; }
        /// <summary>
        /// 初始化
        /// </summary>
        /// <param name="gameObjectCapacity"></param>
        public void Init(int gameObjectCapacity)
        {
            if (IsInit) return;

            Cells = new GameObject[gameObjectCapacity];
            CellsID = new int[gameObjectCapacity];

            IsInit = true;
        }

        public void ResetData()
        {
            //隐藏所有格子
            index = -1;
            for (int i=0;i<Cells.Length;i++)
            {
                if (Cells[i] != null)
                {
                    Cells[i].SetActive(false);
                }
            }
        }
    }
}