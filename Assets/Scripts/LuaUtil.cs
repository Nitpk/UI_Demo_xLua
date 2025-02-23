/*
 * 作者：阳贻凡
 */
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace Demo
{
    /// <summary>
    /// lua工具类
    /// </summary>
    public static class LuaUtil
    {
        // 设置位置
        public static void SetPosition(GameObject obj, float x, float y,bool enableZ = false ,float z = 0f)
        {   
            if(enableZ)
                obj.transform.position = new Vector3(x, y, z);
            else
                obj.transform.position = new Vector3(x, y, obj.transform.position.z);
        }

        // 获取位置
        public static void GetPosition(GameObject obj, out float x, out float y, out float z)
        {
            x = obj.transform.position.x;
            y = obj.transform.position.y;
            z = obj.transform.position.z;
        }

        // 设置旋转
        public static void SetRotation(GameObject obj, float x, float y, float z, float w)
        {
            obj.transform.rotation = new Quaternion(x, y, z, w);
        }

        // 获取旋转
        public static void GetRotation(GameObject obj, out float x, out float y, out float z, out float w)
        {
            x = obj.transform.rotation.x;
            y = obj.transform.rotation.y;
            z = obj.transform.rotation.z;
            w = obj.transform.rotation.w;
        }

        // 设置缩放
        public static void SetScale(GameObject obj, float x, float y, float z)
        {
            obj.transform.localScale = new Vector3(x, y, z);
        }

        // 获取缩放
        public static void GetScale(GameObject obj, out float x, out float y, out float z)
        {
            x = obj.transform.localScale.x;
            y = obj.transform.localScale.y;
            z = obj.transform.localScale.z;
        }
        //得到按钮
        public static Button GetButton(Transform transform,string name = null)
        {
            Button result = null;

            if(name == null)
            {
                result = transform.GetComponent<Button>();
            }
            else
            {
                result = transform.Find(name).GetComponent<Button>();
            }

            return result;
        }

        // 获取Text组件
        public static Text GetText(Transform transform, string name = null)
        {
            Text result = null;

            if (name == null)
            {
                result = transform.GetComponent<Text>();
            }
            else
            {
                
                result = transform.Find(name).GetComponent<Text>();
                
            }

            return result;
        }

        // 获取Toggle组件
        public static Toggle GetToggle(Transform transform, string name = null)
        {
            Toggle result = null;

            if (name == null)
            {
                result = transform.GetComponent<Toggle>();
            }
            else
            {

                result = transform.Find(name).GetComponent<Toggle>();
               
            }

            return result;
        }

        // 获取Image组件
        public static Image GetImage(Transform transform, string name = null)
        {
            Image result = null;

            if (name == null)
            {
                result = transform.GetComponent<Image>();
            }
            else
            {

                result = transform.Find(name).GetComponent<Image>();
                
            }

            return result;
        }

        // 获取RectTransform组件
        public static RectTransform GetRectTransform(Transform transform, string name = null)
        {
            RectTransform result = null;
            if (name == null)
            {
                result = transform.GetComponent<RectTransform>();
            }
            else
            {

                result = transform.Find(name).GetComponent<RectTransform>();
                
            }

            return result;
        }
        //UI本地坐标转世界坐标
        public static void GetUIZeroWorldPosition(Transform  transform,out float x,out float y,out float z)
        {
            Vector3 pos = transform.TransformPoint(Vector3.zero);
            x = pos.x;
            y = pos.y;
            z = pos.z;
        }

        //得到数据（临时）
        public static Dictionary<int,CharacterInfo> GetModelData(){
            return BinaryMgr.Instance.GetTable<CharacterInfoContainer>().dataDic;
        }
    }
}