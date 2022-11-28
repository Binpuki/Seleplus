using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Seleplus
{
    public class Util
    {
        public static float Lerp(float start, float end, float time)
        {
            return ((end - start) * time) + start;
        }
    }
}
