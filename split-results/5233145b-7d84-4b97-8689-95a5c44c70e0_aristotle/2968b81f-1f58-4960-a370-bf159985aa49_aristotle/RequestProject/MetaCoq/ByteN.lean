import RequestProject.MetaCoq.Basic

/-!
# Byte ↔ N mapping

Defines `n0` … `n255` and the `toN` function mapping each `Byte` to
its binary representation as an `N`.
-/

namespace MetaCoq

/-! ### N constants 0–255 -/

def n0   : N := .N0
def n1   : N := .Npos .XH
def n2   : N := .Npos (.XO .XH)
def n3   : N := .Npos (.XI .XH)
def n4   : N := .Npos (.XO (.XO .XH))
def n5   : N := .Npos (.XI (.XO .XH))
def n6   : N := .Npos (.XO (.XI .XH))
def n7   : N := .Npos (.XI (.XI .XH))
def n8   : N := .Npos (.XO (.XO (.XO .XH)))
def n9   : N := .Npos (.XI (.XO (.XO .XH)))
def n10  : N := .Npos (.XO (.XI (.XO .XH)))
def n11  : N := .Npos (.XI (.XI (.XO .XH)))
def n12  : N := .Npos (.XO (.XO (.XI .XH)))
def n13  : N := .Npos (.XI (.XO (.XI .XH)))
def n14  : N := .Npos (.XO (.XI (.XI .XH)))
def n15  : N := .Npos (.XI (.XI (.XI .XH)))
def n16  : N := .Npos (.XO (.XO (.XO (.XO .XH))))
def n17  : N := .Npos (.XI (.XO (.XO (.XO .XH))))
def n18  : N := .Npos (.XO (.XI (.XO (.XO .XH))))
def n19  : N := .Npos (.XI (.XI (.XO (.XO .XH))))
def n20  : N := .Npos (.XO (.XO (.XI (.XO .XH))))
def n21  : N := .Npos (.XI (.XO (.XI (.XO .XH))))
def n22  : N := .Npos (.XO (.XI (.XI (.XO .XH))))
def n23  : N := .Npos (.XI (.XI (.XI (.XO .XH))))
def n24  : N := .Npos (.XO (.XO (.XO (.XI .XH))))
def n25  : N := .Npos (.XI (.XO (.XO (.XI .XH))))
def n26  : N := .Npos (.XO (.XI (.XO (.XI .XH))))
def n27  : N := .Npos (.XI (.XI (.XO (.XI .XH))))
def n28  : N := .Npos (.XO (.XO (.XI (.XI .XH))))
def n29  : N := .Npos (.XI (.XO (.XI (.XI .XH))))
def n30  : N := .Npos (.XO (.XI (.XI (.XI .XH))))
def n31  : N := .Npos (.XI (.XI (.XI (.XI .XH))))
def n32  : N := .Npos (.XO (.XO (.XO (.XO (.XO .XH)))))
def n33  : N := .Npos (.XI (.XO (.XO (.XO (.XO .XH)))))
def n34  : N := .Npos (.XO (.XI (.XO (.XO (.XO .XH)))))
def n35  : N := .Npos (.XI (.XI (.XO (.XO (.XO .XH)))))
def n36  : N := .Npos (.XO (.XO (.XI (.XO (.XO .XH)))))
def n37  : N := .Npos (.XI (.XO (.XI (.XO (.XO .XH)))))
def n38  : N := .Npos (.XO (.XI (.XI (.XO (.XO .XH)))))
def n39  : N := .Npos (.XI (.XI (.XI (.XO (.XO .XH)))))
def n40  : N := .Npos (.XO (.XO (.XO (.XI (.XO .XH)))))
def n41  : N := .Npos (.XI (.XO (.XO (.XI (.XO .XH)))))
def n42  : N := .Npos (.XO (.XI (.XO (.XI (.XO .XH)))))
def n43  : N := .Npos (.XI (.XI (.XO (.XI (.XO .XH)))))
def n44  : N := .Npos (.XO (.XO (.XI (.XI (.XO .XH)))))
def n45  : N := .Npos (.XI (.XO (.XI (.XI (.XO .XH)))))
def n46  : N := .Npos (.XO (.XI (.XI (.XI (.XO .XH)))))
def n47  : N := .Npos (.XI (.XI (.XI (.XI (.XO .XH)))))
def n48  : N := .Npos (.XO (.XO (.XO (.XO (.XI .XH)))))
def n49  : N := .Npos (.XI (.XO (.XO (.XO (.XI .XH)))))
def n50  : N := .Npos (.XO (.XI (.XO (.XO (.XI .XH)))))
def n51  : N := .Npos (.XI (.XI (.XO (.XO (.XI .XH)))))
def n52  : N := .Npos (.XO (.XO (.XI (.XO (.XI .XH)))))
def n53  : N := .Npos (.XI (.XO (.XI (.XO (.XI .XH)))))
def n54  : N := .Npos (.XO (.XI (.XI (.XO (.XI .XH)))))
def n55  : N := .Npos (.XI (.XI (.XI (.XO (.XI .XH)))))
def n56  : N := .Npos (.XO (.XO (.XO (.XI (.XI .XH)))))
def n57  : N := .Npos (.XI (.XO (.XO (.XI (.XI .XH)))))
def n58  : N := .Npos (.XO (.XI (.XO (.XI (.XI .XH)))))
def n59  : N := .Npos (.XI (.XI (.XO (.XI (.XI .XH)))))
def n60  : N := .Npos (.XO (.XO (.XI (.XI (.XI .XH)))))
def n61  : N := .Npos (.XI (.XO (.XI (.XI (.XI .XH)))))
def n62  : N := .Npos (.XO (.XI (.XI (.XI (.XI .XH)))))
def n63  : N := .Npos (.XI (.XI (.XI (.XI (.XI .XH)))))
def n64  : N := .Npos (.XO (.XO (.XO (.XO (.XO (.XO .XH))))))
def n65  : N := .Npos (.XI (.XO (.XO (.XO (.XO (.XO .XH))))))
def n66  : N := .Npos (.XO (.XI (.XO (.XO (.XO (.XO .XH))))))
def n67  : N := .Npos (.XI (.XI (.XO (.XO (.XO (.XO .XH))))))
def n68  : N := .Npos (.XO (.XO (.XI (.XO (.XO (.XO .XH))))))
def n69  : N := .Npos (.XI (.XO (.XI (.XO (.XO (.XO .XH))))))
def n70  : N := .Npos (.XO (.XI (.XI (.XO (.XO (.XO .XH))))))
def n71  : N := .Npos (.XI (.XI (.XI (.XO (.XO (.XO .XH))))))
def n72  : N := .Npos (.XO (.XO (.XO (.XI (.XO (.XO .XH))))))
def n73  : N := .Npos (.XI (.XO (.XO (.XI (.XO (.XO .XH))))))
def n74  : N := .Npos (.XO (.XI (.XO (.XI (.XO (.XO .XH))))))
def n75  : N := .Npos (.XI (.XI (.XO (.XI (.XO (.XO .XH))))))
def n76  : N := .Npos (.XO (.XO (.XI (.XI (.XO (.XO .XH))))))
def n77  : N := .Npos (.XI (.XO (.XI (.XI (.XO (.XO .XH))))))
def n78  : N := .Npos (.XO (.XI (.XI (.XI (.XO (.XO .XH))))))
def n79  : N := .Npos (.XI (.XI (.XI (.XI (.XO (.XO .XH))))))
def n80  : N := .Npos (.XO (.XO (.XO (.XO (.XI (.XO .XH))))))
def n81  : N := .Npos (.XI (.XO (.XO (.XO (.XI (.XO .XH))))))
def n82  : N := .Npos (.XO (.XI (.XO (.XO (.XI (.XO .XH))))))
def n83  : N := .Npos (.XI (.XI (.XO (.XO (.XI (.XO .XH))))))
def n84  : N := .Npos (.XO (.XO (.XI (.XO (.XI (.XO .XH))))))
def n85  : N := .Npos (.XI (.XO (.XI (.XO (.XI (.XO .XH))))))
def n86  : N := .Npos (.XO (.XI (.XI (.XO (.XI (.XO .XH))))))
def n87  : N := .Npos (.XI (.XI (.XI (.XO (.XI (.XO .XH))))))
def n88  : N := .Npos (.XO (.XO (.XO (.XI (.XI (.XO .XH))))))
def n89  : N := .Npos (.XI (.XO (.XO (.XI (.XI (.XO .XH))))))
def n90  : N := .Npos (.XO (.XI (.XO (.XI (.XI (.XO .XH))))))
def n91  : N := .Npos (.XI (.XI (.XO (.XI (.XI (.XO .XH))))))
def n92  : N := .Npos (.XO (.XO (.XI (.XI (.XI (.XO .XH))))))
def n93  : N := .Npos (.XI (.XO (.XI (.XI (.XI (.XO .XH))))))
def n94  : N := .Npos (.XO (.XI (.XI (.XI (.XI (.XO .XH))))))
def n95  : N := .Npos (.XI (.XI (.XI (.XI (.XI (.XO .XH))))))
def n96  : N := .Npos (.XO (.XO (.XO (.XO (.XO (.XI .XH))))))
def n97  : N := .Npos (.XI (.XO (.XO (.XO (.XO (.XI .XH))))))
def n98  : N := .Npos (.XO (.XI (.XO (.XO (.XO (.XI .XH))))))
def n99  : N := .Npos (.XI (.XI (.XO (.XO (.XO (.XI .XH))))))
def n100 : N := .Npos (.XO (.XO (.XI (.XO (.XO (.XI .XH))))))
def n101 : N := .Npos (.XI (.XO (.XI (.XO (.XO (.XI .XH))))))
def n102 : N := .Npos (.XO (.XI (.XI (.XO (.XO (.XI .XH))))))
def n103 : N := .Npos (.XI (.XI (.XI (.XO (.XO (.XI .XH))))))
def n104 : N := .Npos (.XO (.XO (.XO (.XI (.XO (.XI .XH))))))
def n105 : N := .Npos (.XI (.XO (.XO (.XI (.XO (.XI .XH))))))
def n106 : N := .Npos (.XO (.XI (.XO (.XI (.XO (.XI .XH))))))
def n107 : N := .Npos (.XI (.XI (.XO (.XI (.XO (.XI .XH))))))
def n108 : N := .Npos (.XO (.XO (.XI (.XI (.XO (.XI .XH))))))
def n109 : N := .Npos (.XI (.XO (.XI (.XI (.XO (.XI .XH))))))
def n110 : N := .Npos (.XO (.XI (.XI (.XI (.XO (.XI .XH))))))
def n111 : N := .Npos (.XI (.XI (.XI (.XI (.XO (.XI .XH))))))
def n112 : N := .Npos (.XO (.XO (.XO (.XO (.XI (.XI .XH))))))
def n113 : N := .Npos (.XI (.XO (.XO (.XO (.XI (.XI .XH))))))
def n114 : N := .Npos (.XO (.XI (.XO (.XO (.XI (.XI .XH))))))
def n115 : N := .Npos (.XI (.XI (.XO (.XO (.XI (.XI .XH))))))
def n116 : N := .Npos (.XO (.XO (.XI (.XO (.XI (.XI .XH))))))
def n117 : N := .Npos (.XI (.XO (.XI (.XO (.XI (.XI .XH))))))
def n118 : N := .Npos (.XO (.XI (.XI (.XO (.XI (.XI .XH))))))
def n119 : N := .Npos (.XI (.XI (.XI (.XO (.XI (.XI .XH))))))
def n120 : N := .Npos (.XO (.XO (.XO (.XI (.XI (.XI .XH))))))
def n121 : N := .Npos (.XI (.XO (.XO (.XI (.XI (.XI .XH))))))
def n122 : N := .Npos (.XO (.XI (.XO (.XI (.XI (.XI .XH))))))
def n123 : N := .Npos (.XI (.XI (.XO (.XI (.XI (.XI .XH))))))
def n124 : N := .Npos (.XO (.XO (.XI (.XI (.XI (.XI .XH))))))
def n125 : N := .Npos (.XI (.XO (.XI (.XI (.XI (.XI .XH))))))
def n126 : N := .Npos (.XO (.XI (.XI (.XI (.XI (.XI .XH))))))
def n127 : N := .Npos (.XI (.XI (.XI (.XI (.XI (.XI .XH))))))
def n128 : N := .Npos (.XO (.XO (.XO (.XO (.XO (.XO (.XO .XH)))))))
def n129 : N := .Npos (.XI (.XO (.XO (.XO (.XO (.XO (.XO .XH)))))))
def n130 : N := .Npos (.XO (.XI (.XO (.XO (.XO (.XO (.XO .XH)))))))
def n131 : N := .Npos (.XI (.XI (.XO (.XO (.XO (.XO (.XO .XH)))))))
def n132 : N := .Npos (.XO (.XO (.XI (.XO (.XO (.XO (.XO .XH)))))))
def n133 : N := .Npos (.XI (.XO (.XI (.XO (.XO (.XO (.XO .XH)))))))
def n134 : N := .Npos (.XO (.XI (.XI (.XO (.XO (.XO (.XO .XH)))))))
def n135 : N := .Npos (.XI (.XI (.XI (.XO (.XO (.XO (.XO .XH)))))))
def n136 : N := .Npos (.XO (.XO (.XO (.XI (.XO (.XO (.XO .XH)))))))
def n137 : N := .Npos (.XI (.XO (.XO (.XI (.XO (.XO (.XO .XH)))))))
def n138 : N := .Npos (.XO (.XI (.XO (.XI (.XO (.XO (.XO .XH)))))))
def n139 : N := .Npos (.XI (.XI (.XO (.XI (.XO (.XO (.XO .XH)))))))
def n140 : N := .Npos (.XO (.XO (.XI (.XI (.XO (.XO (.XO .XH)))))))
def n141 : N := .Npos (.XI (.XO (.XI (.XI (.XO (.XO (.XO .XH)))))))
def n142 : N := .Npos (.XO (.XI (.XI (.XI (.XO (.XO (.XO .XH)))))))
def n143 : N := .Npos (.XI (.XI (.XI (.XI (.XO (.XO (.XO .XH)))))))
def n144 : N := .Npos (.XO (.XO (.XO (.XO (.XI (.XO (.XO .XH)))))))
def n145 : N := .Npos (.XI (.XO (.XO (.XO (.XI (.XO (.XO .XH)))))))
def n146 : N := .Npos (.XO (.XI (.XO (.XO (.XI (.XO (.XO .XH)))))))
def n147 : N := .Npos (.XI (.XI (.XO (.XO (.XI (.XO (.XO .XH)))))))
def n148 : N := .Npos (.XO (.XO (.XI (.XO (.XI (.XO (.XO .XH)))))))
def n149 : N := .Npos (.XI (.XO (.XI (.XO (.XI (.XO (.XO .XH)))))))
def n150 : N := .Npos (.XO (.XI (.XI (.XO (.XI (.XO (.XO .XH)))))))
def n151 : N := .Npos (.XI (.XI (.XI (.XO (.XI (.XO (.XO .XH)))))))
def n152 : N := .Npos (.XO (.XO (.XO (.XI (.XI (.XO (.XO .XH)))))))
def n153 : N := .Npos (.XI (.XO (.XO (.XI (.XI (.XO (.XO .XH)))))))
def n154 : N := .Npos (.XO (.XI (.XO (.XI (.XI (.XO (.XO .XH)))))))
def n155 : N := .Npos (.XI (.XI (.XO (.XI (.XI (.XO (.XO .XH)))))))
def n156 : N := .Npos (.XO (.XO (.XI (.XI (.XI (.XO (.XO .XH)))))))
def n157 : N := .Npos (.XI (.XO (.XI (.XI (.XI (.XO (.XO .XH)))))))
def n158 : N := .Npos (.XO (.XI (.XI (.XI (.XI (.XO (.XO .XH)))))))
def n159 : N := .Npos (.XI (.XI (.XI (.XI (.XI (.XO (.XO .XH)))))))
def n160 : N := .Npos (.XO (.XO (.XO (.XO (.XO (.XI (.XO .XH)))))))
def n161 : N := .Npos (.XI (.XO (.XO (.XO (.XO (.XI (.XO .XH)))))))
def n162 : N := .Npos (.XO (.XI (.XO (.XO (.XO (.XI (.XO .XH)))))))
def n163 : N := .Npos (.XI (.XI (.XO (.XO (.XO (.XI (.XO .XH)))))))
def n164 : N := .Npos (.XO (.XO (.XI (.XO (.XO (.XI (.XO .XH)))))))
def n165 : N := .Npos (.XI (.XO (.XI (.XO (.XO (.XI (.XO .XH)))))))
def n166 : N := .Npos (.XO (.XI (.XI (.XO (.XO (.XI (.XO .XH)))))))
def n167 : N := .Npos (.XI (.XI (.XI (.XO (.XO (.XI (.XO .XH)))))))
def n168 : N := .Npos (.XO (.XO (.XO (.XI (.XO (.XI (.XO .XH)))))))
def n169 : N := .Npos (.XI (.XO (.XO (.XI (.XO (.XI (.XO .XH)))))))
def n170 : N := .Npos (.XO (.XI (.XO (.XI (.XO (.XI (.XO .XH)))))))
def n171 : N := .Npos (.XI (.XI (.XO (.XI (.XO (.XI (.XO .XH)))))))
def n172 : N := .Npos (.XO (.XO (.XI (.XI (.XO (.XI (.XO .XH)))))))
def n173 : N := .Npos (.XI (.XO (.XI (.XI (.XO (.XI (.XO .XH)))))))
def n174 : N := .Npos (.XO (.XI (.XI (.XI (.XO (.XI (.XO .XH)))))))
def n175 : N := .Npos (.XI (.XI (.XI (.XI (.XO (.XI (.XO .XH)))))))
def n176 : N := .Npos (.XO (.XO (.XO (.XO (.XI (.XI (.XO .XH)))))))
def n177 : N := .Npos (.XI (.XO (.XO (.XO (.XI (.XI (.XO .XH)))))))
def n178 : N := .Npos (.XO (.XI (.XO (.XO (.XI (.XI (.XO .XH)))))))
def n179 : N := .Npos (.XI (.XI (.XO (.XO (.XI (.XI (.XO .XH)))))))
def n180 : N := .Npos (.XO (.XO (.XI (.XO (.XI (.XI (.XO .XH)))))))
def n181 : N := .Npos (.XI (.XO (.XI (.XO (.XI (.XI (.XO .XH)))))))
def n182 : N := .Npos (.XO (.XI (.XI (.XO (.XI (.XI (.XO .XH)))))))
def n183 : N := .Npos (.XI (.XI (.XI (.XO (.XI (.XI (.XO .XH)))))))
def n184 : N := .Npos (.XO (.XO (.XO (.XI (.XI (.XI (.XO .XH)))))))
def n185 : N := .Npos (.XI (.XO (.XO (.XI (.XI (.XI (.XO .XH)))))))
def n186 : N := .Npos (.XO (.XI (.XO (.XI (.XI (.XI (.XO .XH)))))))
def n187 : N := .Npos (.XI (.XI (.XO (.XI (.XI (.XI (.XO .XH)))))))
def n188 : N := .Npos (.XO (.XO (.XI (.XI (.XI (.XI (.XO .XH)))))))
def n189 : N := .Npos (.XI (.XO (.XI (.XI (.XI (.XI (.XO .XH)))))))
def n190 : N := .Npos (.XO (.XI (.XI (.XI (.XI (.XI (.XO .XH)))))))
def n191 : N := .Npos (.XI (.XI (.XI (.XI (.XI (.XI (.XO .XH)))))))
def n192 : N := .Npos (.XO (.XO (.XO (.XO (.XO (.XO (.XI .XH)))))))
def n193 : N := .Npos (.XI (.XO (.XO (.XO (.XO (.XO (.XI .XH)))))))
def n194 : N := .Npos (.XO (.XI (.XO (.XO (.XO (.XO (.XI .XH)))))))
def n195 : N := .Npos (.XI (.XI (.XO (.XO (.XO (.XO (.XI .XH)))))))
def n196 : N := .Npos (.XO (.XO (.XI (.XO (.XO (.XO (.XI .XH)))))))
def n197 : N := .Npos (.XI (.XO (.XI (.XO (.XO (.XO (.XI .XH)))))))
def n198 : N := .Npos (.XO (.XI (.XI (.XO (.XO (.XO (.XI .XH)))))))
def n199 : N := .Npos (.XI (.XI (.XI (.XO (.XO (.XO (.XI .XH)))))))
def n200 : N := .Npos (.XO (.XO (.XO (.XI (.XO (.XO (.XI .XH)))))))
def n201 : N := .Npos (.XI (.XO (.XO (.XI (.XO (.XO (.XI .XH)))))))
def n202 : N := .Npos (.XO (.XI (.XO (.XI (.XO (.XO (.XI .XH)))))))
def n203 : N := .Npos (.XI (.XI (.XO (.XI (.XO (.XO (.XI .XH)))))))
def n204 : N := .Npos (.XO (.XO (.XI (.XI (.XO (.XO (.XI .XH)))))))
def n205 : N := .Npos (.XI (.XO (.XI (.XI (.XO (.XO (.XI .XH)))))))
def n206 : N := .Npos (.XO (.XI (.XI (.XI (.XO (.XO (.XI .XH)))))))
def n207 : N := .Npos (.XI (.XI (.XI (.XI (.XO (.XO (.XI .XH)))))))
def n208 : N := .Npos (.XO (.XO (.XO (.XO (.XI (.XO (.XI .XH)))))))
def n209 : N := .Npos (.XI (.XO (.XO (.XO (.XI (.XO (.XI .XH)))))))
def n210 : N := .Npos (.XO (.XI (.XO (.XO (.XI (.XO (.XI .XH)))))))
def n211 : N := .Npos (.XI (.XI (.XO (.XO (.XI (.XO (.XI .XH)))))))
def n212 : N := .Npos (.XO (.XO (.XI (.XO (.XI (.XO (.XI .XH)))))))
def n213 : N := .Npos (.XI (.XO (.XI (.XO (.XI (.XO (.XI .XH)))))))
def n214 : N := .Npos (.XO (.XI (.XI (.XO (.XI (.XO (.XI .XH)))))))
def n215 : N := .Npos (.XI (.XI (.XI (.XO (.XI (.XO (.XI .XH)))))))
def n216 : N := .Npos (.XO (.XO (.XO (.XI (.XI (.XO (.XI .XH)))))))
def n217 : N := .Npos (.XI (.XO (.XO (.XI (.XI (.XO (.XI .XH)))))))
def n218 : N := .Npos (.XO (.XI (.XO (.XI (.XI (.XO (.XI .XH)))))))
def n219 : N := .Npos (.XI (.XI (.XO (.XI (.XI (.XO (.XI .XH)))))))
def n220 : N := .Npos (.XO (.XO (.XI (.XI (.XI (.XO (.XI .XH)))))))
def n221 : N := .Npos (.XI (.XO (.XI (.XI (.XI (.XO (.XI .XH)))))))
def n222 : N := .Npos (.XO (.XI (.XI (.XI (.XI (.XO (.XI .XH)))))))
def n223 : N := .Npos (.XI (.XI (.XI (.XI (.XI (.XO (.XI .XH)))))))
def n224 : N := .Npos (.XO (.XO (.XO (.XO (.XO (.XI (.XI .XH)))))))
def n225 : N := .Npos (.XI (.XO (.XO (.XO (.XO (.XI (.XI .XH)))))))
def n226 : N := .Npos (.XO (.XI (.XO (.XO (.XO (.XI (.XI .XH)))))))
def n227 : N := .Npos (.XI (.XI (.XO (.XO (.XO (.XI (.XI .XH)))))))
def n228 : N := .Npos (.XO (.XO (.XI (.XO (.XO (.XI (.XI .XH)))))))
def n229 : N := .Npos (.XI (.XO (.XI (.XO (.XO (.XI (.XI .XH)))))))
def n230 : N := .Npos (.XO (.XI (.XI (.XO (.XO (.XI (.XI .XH)))))))
def n231 : N := .Npos (.XI (.XI (.XI (.XO (.XO (.XI (.XI .XH)))))))
def n232 : N := .Npos (.XO (.XO (.XO (.XI (.XO (.XI (.XI .XH)))))))
def n233 : N := .Npos (.XI (.XO (.XO (.XI (.XO (.XI (.XI .XH)))))))
def n234 : N := .Npos (.XO (.XI (.XO (.XI (.XO (.XI (.XI .XH)))))))
def n235 : N := .Npos (.XI (.XI (.XO (.XI (.XO (.XI (.XI .XH)))))))
def n236 : N := .Npos (.XO (.XO (.XI (.XI (.XO (.XI (.XI .XH)))))))
def n237 : N := .Npos (.XI (.XO (.XI (.XI (.XO (.XI (.XI .XH)))))))
def n238 : N := .Npos (.XO (.XI (.XI (.XI (.XO (.XI (.XI .XH)))))))
def n239 : N := .Npos (.XI (.XI (.XI (.XI (.XO (.XI (.XI .XH)))))))
def n240 : N := .Npos (.XO (.XO (.XO (.XO (.XI (.XI (.XI .XH)))))))
def n241 : N := .Npos (.XI (.XO (.XO (.XO (.XI (.XI (.XI .XH)))))))
def n242 : N := .Npos (.XO (.XI (.XO (.XO (.XI (.XI (.XI .XH)))))))
def n243 : N := .Npos (.XI (.XI (.XO (.XO (.XI (.XI (.XI .XH)))))))
def n244 : N := .Npos (.XO (.XO (.XI (.XO (.XI (.XI (.XI .XH)))))))
def n245 : N := .Npos (.XI (.XO (.XI (.XO (.XI (.XI (.XI .XH)))))))
def n246 : N := .Npos (.XO (.XI (.XI (.XO (.XI (.XI (.XI .XH)))))))
def n247 : N := .Npos (.XI (.XI (.XI (.XO (.XI (.XI (.XI .XH)))))))
def n248 : N := .Npos (.XO (.XO (.XO (.XI (.XI (.XI (.XI .XH)))))))
def n249 : N := .Npos (.XI (.XO (.XO (.XI (.XI (.XI (.XI .XH)))))))
def n250 : N := .Npos (.XO (.XI (.XO (.XI (.XI (.XI (.XI .XH)))))))
def n251 : N := .Npos (.XI (.XI (.XO (.XI (.XI (.XI (.XI .XH)))))))
def n252 : N := .Npos (.XO (.XO (.XI (.XI (.XI (.XI (.XI .XH)))))))
def n253 : N := .Npos (.XI (.XO (.XI (.XI (.XI (.XI (.XI .XH)))))))
def n254 : N := .Npos (.XO (.XI (.XI (.XI (.XI (.XI (.XI .XH)))))))
def n255 : N := .Npos (.XI (.XI (.XI (.XI (.XI (.XI (.XI .XH)))))))

/-! ### toN : Byte → N -/

def toN : Byte → N
  | .X00 => n0   | .X01 => n1   | .X02 => n2   | .X03 => n3
  | .X04 => n4   | .X05 => n5   | .X06 => n6   | .X07 => n7
  | .X08 => n8   | .X09 => n9   | .X0a => n10  | .X0b => n11
  | .X0c => n12  | .X0d => n13  | .X0e => n14  | .X0f => n15
  | .X10 => n16  | .X11 => n17  | .X12 => n18  | .X13 => n19
  | .X14 => n20  | .X15 => n21  | .X16 => n22  | .X17 => n23
  | .X18 => n24  | .X19 => n25  | .X1a => n26  | .X1b => n27
  | .X1c => n28  | .X1d => n29  | .X1e => n30  | .X1f => n31
  | .X20 => n32  | .X21 => n33  | .X22 => n34  | .X23 => n35
  | .X24 => n36  | .X25 => n37  | .X26 => n38  | .X27 => n39
  | .X28 => n40  | .X29 => n41  | .X2a => n42  | .X2b => n43
  | .X2c => n44  | .X2d => n45  | .X2e => n46  | .X2f => n47
  | .X30 => n48  | .X31 => n49  | .X32 => n50  | .X33 => n51
  | .X34 => n52  | .X35 => n53  | .X36 => n54  | .X37 => n55
  | .X38 => n56  | .X39 => n57  | .X3a => n58  | .X3b => n59
  | .X3c => n60  | .X3d => n61  | .X3e => n62  | .X3f => n63
  | .X40 => n64  | .X41 => n65  | .X42 => n66  | .X43 => n67
  | .X44 => n68  | .X45 => n69  | .X46 => n70  | .X47 => n71
  | .X48 => n72  | .X49 => n73  | .X4a => n74  | .X4b => n75
  | .X4c => n76  | .X4d => n77  | .X4e => n78  | .X4f => n79
  | .X50 => n80  | .X51 => n81  | .X52 => n82  | .X53 => n83
  | .X54 => n84  | .X55 => n85  | .X56 => n86  | .X57 => n87
  | .X58 => n88  | .X59 => n89  | .X5a => n90  | .X5b => n91
  | .X5c => n92  | .X5d => n93  | .X5e => n94  | .X5f => n95
  | .X60 => n96  | .X61 => n97  | .X62 => n98  | .X63 => n99
  | .X64 => n100 | .X65 => n101 | .X66 => n102 | .X67 => n103
  | .X68 => n104 | .X69 => n105 | .X6a => n106 | .X6b => n107
  | .X6c => n108 | .X6d => n109 | .X6e => n110 | .X6f => n111
  | .X70 => n112 | .X71 => n113 | .X72 => n114 | .X73 => n115
  | .X74 => n116 | .X75 => n117 | .X76 => n118 | .X77 => n119
  | .X78 => n120 | .X79 => n121 | .X7a => n122 | .X7b => n123
  | .X7c => n124 | .X7d => n125 | .X7e => n126 | .X7f => n127
  | .X80 => n128 | .X81 => n129 | .X82 => n130 | .X83 => n131
  | .X84 => n132 | .X85 => n133 | .X86 => n134 | .X87 => n135
  | .X88 => n136 | .X89 => n137 | .X8a => n138 | .X8b => n139
  | .X8c => n140 | .X8d => n141 | .X8e => n142 | .X8f => n143
  | .X90 => n144 | .X91 => n145 | .X92 => n146 | .X93 => n147
  | .X94 => n148 | .X95 => n149 | .X96 => n150 | .X97 => n151
  | .X98 => n152 | .X99 => n153 | .X9a => n154 | .X9b => n155
  | .X9c => n156 | .X9d => n157 | .X9e => n158 | .X9f => n159
  | .Xa0 => n160 | .Xa1 => n161 | .Xa2 => n162 | .Xa3 => n163
  | .Xa4 => n164 | .Xa5 => n165 | .Xa6 => n166 | .Xa7 => n167
  | .Xa8 => n168 | .Xa9 => n169 | .Xaa => n170 | .Xab => n171
  | .Xac => n172 | .Xad => n173 | .Xae => n174 | .Xaf => n175
  | .Xb0 => n176 | .Xb1 => n177 | .Xb2 => n178 | .Xb3 => n179
  | .Xb4 => n180 | .Xb5 => n181 | .Xb6 => n182 | .Xb7 => n183
  | .Xb8 => n184 | .Xb9 => n185 | .Xba => n186 | .Xbb => n187
  | .Xbc => n188 | .Xbd => n189 | .Xbe => n190 | .Xbf => n191
  | .Xc0 => n192 | .Xc1 => n193 | .Xc2 => n194 | .Xc3 => n195
  | .Xc4 => n196 | .Xc5 => n197 | .Xc6 => n198 | .Xc7 => n199
  | .Xc8 => n200 | .Xc9 => n201 | .Xca => n202 | .Xcb => n203
  | .Xcc => n204 | .Xcd => n205 | .Xce => n206 | .Xcf => n207
  | .Xd0 => n208 | .Xd1 => n209 | .Xd2 => n210 | .Xd3 => n211
  | .Xd4 => n212 | .Xd5 => n213 | .Xd6 => n214 | .Xd7 => n215
  | .Xd8 => n216 | .Xd9 => n217 | .Xda => n218 | .Xdb => n219
  | .Xdc => n220 | .Xdd => n221 | .Xde => n222 | .Xdf => n223
  | .Xe0 => n224 | .Xe1 => n225 | .Xe2 => n226 | .Xe3 => n227
  | .Xe4 => n228 | .Xe5 => n229 | .Xe6 => n230 | .Xe7 => n231
  | .Xe8 => n232 | .Xe9 => n233 | .Xea => n234 | .Xeb => n235
  | .Xec => n236 | .Xed => n237 | .Xee => n238 | .Xef => n239
  | .Xf0 => n240 | .Xf1 => n241 | .Xf2 => n242 | .Xf3 => n243
  | .Xf4 => n244 | .Xf5 => n245 | .Xf6 => n246 | .Xf7 => n247
  | .Xf8 => n248 | .Xf9 => n249 | .Xfa => n250 | .Xfb => n251
  | .Xfc => n252 | .Xfd => n253 | .Xfe => n254 | .Xff => n255

end MetaCoq
