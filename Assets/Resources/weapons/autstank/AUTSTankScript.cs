using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Seleplus.Objects.Weapons
{
    public class AUTSTankScript : RangedWeapon
    {
        [SerializeField] private GameObject Bullet;

        private void Start()
        {
            StartCoroutine(ShootCoroutine());
        }

        protected override void Update()
        {
            // I KNOW THIS IS BAD BUT IT WORKS FOR NOW, I WILL REWORK LATER ;-;
            Vector2 mouseCalc = new Vector2(FindObjectOfType<Player.Player>().transform.position.x - gunBarrel.position.x, FindObjectOfType<Player.Player>().transform.position.y - gunBarrel.position.y);

            angle = (Mathf.Atan2(mouseCalc.y, mouseCalc.x));
            angleDegrees = angle * (180f / Mathf.PI);
            transform.position = new Vector3(center.position.x + (radius * Mathf.Cos(angle)), center.position.y + (radius * Mathf.Sin(angle)), center.position.z);

            Quaternion rotation = Quaternion.Euler(transform.rotation.eulerAngles.x, transform.rotation.eulerAngles.y, angleDegrees);
            transform.rotation = rotation;
        }

        IEnumerator ShootCoroutine()
        {
            while (true)
            {
                yield return new WaitForSeconds(UnityEngine.Random.Range(1f, 2f));

                var bullet = Instantiate(Bullet);
                bullet.GetComponent<Bullet>().Setup(gunBarrel.position, FindObjectOfType<Player.Player>().transform.position, angleDegrees);
            }
        }
    }
}